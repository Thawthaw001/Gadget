// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:thaw/Widget/model_provider.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   PaymentPageState createState() => PaymentPageState();
// }

// class PaymentPageState extends State<PaymentPage> {
//   final _formKey = GlobalKey<FormState>();

//   String _state = '';
//   String _township = '';
//   String _streetAddress = '';
//   String _phone = '';
//   String _email = '';
//   String _additionalInfo = '';
//   String? _userId;
//   String? _userName;
//   String? _userEmail;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//       if (userDoc.exists) {
//         setState(() {
//           _userId = currentUser.uid;
//           _userName = userDoc.data()?['name'];
//           _userEmail = userDoc.data()?['email'];
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'State'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter state';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _state = value!;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Township'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter township';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _township = value!;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Street Address'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter street address';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _streetAddress = value!;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _phone = value!;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter email';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _email = value!;
//                 },
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: 'Additional Information'),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter additional information';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _additionalInfo = value!;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     final modelProvider =
//                         Provider.of<ModelProvider>(context, listen: false);
//                     final basket = modelProvider.basket;
//                     final total = modelProvider.basket.fold<double>(
//                       0.0,
//                       (sum, item) => sum + item['price'] * item['quantity'],
//                     );

//                     if (_userId != null &&
//                         _userName != null &&
//                         _userEmail != null) {
//                       await FirebaseFirestore.instance
//                           .collection('orders')
//                           .add({
//                         'userId': _userId,
//                         'userName': _userName,
//                         'userEmail': _userEmail,
//                         'totalAmount': total,
//                         'items': basket
//                             .map((item) => {
//                                   'itemName': item['name'],
//                                   'quantity': item['quantity'],
//                                   'price': item['price'],
//                                   'subtotal': item['price'] * item['quantity'],
//                                   'imageUrl': item['imageUrl']
//                                 })
//                             .toList(),
//                         'orderDate': DateTime.now(),
//                         'state': _state,
//                         'township': _township,
//                         'streetAddress': _streetAddress,
//                         'phone': _phone,
//                         'email': _email,
//                         'additionalInfo': _additionalInfo,
//                       });

//                       modelProvider.clearBasket();

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Order placed successfully!'),
//                         ),
//                       );
//                       Navigator.pop(context);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('User data not found!'),
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text('Confirm Payment'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thaw/Pages/pdf_invoice.dart';
import 'package:thaw/Widget/model_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String _state = '';
  String _township = '';
  String _streetAddress = '';
  String _phone = '';
  String _email = '';
  String _additionalInfo = '';
  String? _userId;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _userId = currentUser.uid;
          _userName = userDoc.data()?['name'];
          _userEmail = userDoc.data()?['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
                onSaved: (value) {
                  _state = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Township'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter township';
                  }
                  return null;
                },
                onSaved: (value) {
                  _township = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Street Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _streetAddress = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Additional Information'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter additional information';
                  }
                  return null;
                },
                onSaved: (value) {
                  _additionalInfo = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final modelProvider =
                        Provider.of<ModelProvider>(context, listen: false);
                    final basket = modelProvider.basket;
                    final total = modelProvider.basket.fold<double>(
                      0.0,
                      (sum, item) => sum + item['price'] * item['quantity'],
                    );

                    if (_userId != null &&
                        _userName != null &&
                        _userEmail != null) {
                      final orderRef = await FirebaseFirestore.instance
                          .collection('orders')
                          .add({
                        'userId': _userId,
                        'userName': _userName,
                        'userEmail': _userEmail,
                        'totalAmount': total,
                        'items': basket
                            .map((item) => {
                                  'itemName': item['name'],
                                  'quantity': item['quantity'],
                                  'price': item['price'],
                                  'subtotal': item['price'] * item['quantity'],
                                  'imageUrl': item['imageUrl']
                                })
                            .toList(),
                        'orderDate': DateTime.now(),
                        'state': _state,
                        'township': _township,
                        'streetAddress': _streetAddress,
                        'phone': _phone,
                        'email': _email,
                        'additionalInfo': _additionalInfo,
                      });

                      modelProvider.clearBasket();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully!'),
                        ),
                      );

                      final orderData = {
                        'orderId': orderRef.id,
                        'orderDate': DateTime.now(),
                        'userId': _userId,
                        'userName': _userName,
                        'userEmail': _userEmail,
                        'totalAmount': total,
                        'items': basket,
                      };
                      await generateInvoice(orderData);

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User data not found!'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
