// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// import 'package:thaw/Pages/pdf_invoice.dart';
// import 'package:thaw/utils/formfield.dart';

// class PaymentPage extends StatefulWidget {
//   final List<Map<String, dynamic>> basket;

//   const PaymentPage({super.key, required this.basket});

//   @override
//   PaymentPageState createState() => PaymentPageState();
// }

// class PaymentPageState extends State<PaymentPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Variables to store user input
//   String _state = '';
//   String _township = '';
//   String _streetAddress = '';
//   String _phone = '';
//   String _additionalInfo = '';
//   String _deliveryMethod = 'Online Payment';
//   String _selectedPhoneNumber = '';
//   String _paymentMethod = '';
//   File? _transactionImage;

//   // User details variables
//   String? _userId;
//   String? _userName;
//   String? _userEmail;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   // Fetch the current user's data from Firestore
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
//           _userName = userDoc.data()?['name'] ?? 'No name available';
//           _userEmail = userDoc.data()?['email'] ?? 'No email available';
//         });
//       }
//     }
//   }

//   // Function to pick an image from the gallery
//   Future<void> _pickTransactionImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _transactionImage = File(pickedFile.path);
//       });
//     }
//   }

//   // Save the order details to Firestore and generate the PDF invoice
//   Future<void> _saveOrder() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       _formKey.currentState?.save();

//       // Debugging: Print the input data before saving
//       print('State: $_state');
//       print('Township: $_township');
//       print('Street Address: $_streetAddress');
//       print('Phone: $_phone');

//       String? transactionImageUrl;
//       if (_transactionImage != null) {
//         // Upload the transaction image to Firebase Storage
//         final storageRef = FirebaseStorage.instance.ref().child(
//             'transaction_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
//         final uploadTask = storageRef.putFile(_transactionImage!);
//         final snapshot = await uploadTask;
//         transactionImageUrl = await snapshot.ref.getDownloadURL();
//       }

//       final orderData = {
//         'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
//         'orderDate': DateTime.now(),
//         'userId': _userId,
//         'userName': _userName,
//         'userEmail': _userEmail,
//         'state': _state,
//         'township': _township,
//         'streetAddress': _streetAddress,
//         'phone': _phone,
//         'additionalInfo': _additionalInfo,
//         'deliveryMethod': _deliveryMethod,
//         'paymentMethod': _paymentMethod,
//         'transactionImageUrl': transactionImageUrl,
//         'items': widget.basket,
//         'totalAmount': widget.basket.fold<double>(
//           0.0,
//           (sum, item) => sum + item['price'] * item['quantity'],
//         ),
//       };

//       // Save order to Firestore
//       await FirebaseFirestore.instance.collection('orders').add(orderData);

//       // Show payment success message
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Payment Successful'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Your payment was successful! Thank you for your purchase.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Order Details',
//                   style: formfieldStyle,
//                 ),
//                 const SizedBox(height: 8),
//                 for (var item in widget.basket)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: Text(
//                       '- ${item['name']} (Qty: ${item['quantity']}) - ${item['price']} K',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Total Amount: ${widget.basket.fold<double>(0.0, (sum, item) => sum + item['price'] * item['quantity'])} K',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.blueAccent,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'An invoice has been generated and saved for your records.',
//                   style: formfieldStyle,
//                 ),
//               ],
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   // Reset the form and state variables
//                   _formKey.currentState?.reset();
//                   setState(() {
//                     _state = '';
//                     _township = '';
//                     _streetAddress = '';
//                     _phone = '';
//                     _additionalInfo = '';
//                     _deliveryMethod = 'Online Payment';
//                     _selectedPhoneNumber = '';
//                     _paymentMethod = '';
//                     _transactionImage = null;
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );

//       await generateInvoice(orderData, _transactionImage);
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
//               // State input field
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
//               // Township input field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Township'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Divison and Township';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _township = value!;
//                 },
//               ),
//               // Street Address input field
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
//               // Phone input field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   } else if (value.length != 11) {
//                     return 'Phone number must be exactly 11 digits';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _phone = value!;
//                 },
//               ),

//               // Additional Information input field
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: 'Additional Information'),
//                 onSaved: (value) {
//                   _additionalInfo = value ?? '';
//                 },
//               ),
//               const SizedBox(height: 20),

//               // Section title for Payment Method
//               const Text(
//                 'Payment Method',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),

//               // Payment method options
//               _buildPaymentMethodOption(
//                   'KPay', 'assets/images/pay.png', '09989662010'),
//               _buildPaymentMethodOption(
//                   'WavePay', 'assets/images/pay1.png', '09989662010'),
//               _buildPaymentMethodOption(
//                   'AyaPay', 'assets/images/pay2.png', '09989662010'),
//               _buildPaymentMethodOption(
//                   'CBPay', 'assets/images/pay3.png', '09989662010'),
//               // Display transaction image if available
//               if (_transactionImage != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Image.file(
//                     _transactionImage!,
//                     height: 200, // Adjust as needed
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),

//               // Button to pick the transaction image
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _pickTransactionImage,
//                 child: const Text('Upload Transaction Image'),
//               ),
//               const SizedBox(height: 20),

//               // Save Order Button
//               ElevatedButton(
//                 onPressed: _saveOrder,
//                 child: const Text('Confirm Payment'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build payment method options
//   Widget _buildPaymentMethodOption(
//       String title, String imagePath, String phoneNumber) {
//     return RadioListTile<String>(
//       title: Text(title),
//       secondary: Image.asset(imagePath, width: 50),
//       value: title,
//       groupValue: _paymentMethod,
//       onChanged: (value) {
//         setState(() {
//           _paymentMethod = value!;
//           _selectedPhoneNumber = phoneNumber;
//         });
//       },
//       subtitle: Text(_selectedPhoneNumber),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:thaw/Pages/pdf_invoice.dart';
import 'package:thaw/utils/formfield.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> basket;

  const PaymentPage({super.key, required this.basket});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store user input
  String _township = '';
  String _streetAddress = '';
  String _phone = '';
  String _additionalInfo = '';
  String _deliveryMethod = 'Online Payment';
  String _paymentMethod = '';
  File? _transactionImage;

  // User details variables
  String? _userId;
  String? _userName;
  String? _userEmail;

  // Loading state for confirming payment
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch the current user's data from Firestore
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
          _userName = userDoc.data()?['name'] ?? 'No name available';
          _userEmail = userDoc.data()?['email'] ?? 'No email available';
        });
      }
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickTransactionImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _transactionImage = File(pickedFile.path);
      });
    }
  }

  // Save the order details to Firestore and generate the PDF invoice
  Future<void> _saveOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      String? transactionImageUrl;
      if (_transactionImage != null) {
        // Upload the transaction image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child(
            'transaction_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(_transactionImage!);
        final snapshot = await uploadTask;
        transactionImageUrl = await snapshot.ref.getDownloadURL();
      }

      final orderData = {
        'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
        'orderDate': DateTime.now(),
        'userId': _userId,
        'userName': _userName,
        'userEmail': _userEmail,
        'township': _township,
        'streetAddress': _streetAddress,
        'phone': _phone,
        'additionalInfo': _additionalInfo,
        'deliveryMethod': _deliveryMethod,
        'paymentMethod': _paymentMethod,
        'transactionImageUrl': transactionImageUrl,
        'items': widget.basket,
        'totalAmount': widget.basket.fold<double>(
          0.0,
          (sum, item) => sum + item['price'] * item['quantity'],
        ),
      };

      // Save order to Firestore
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      setState(() {
        _isLoading = false;
      });

      // Show payment success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Payment Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your payment was successful! Thank you for your purchase.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Order Details',
                  style: formfieldStyle,
                ),
                const SizedBox(height: 8),
                for (var item in widget.basket)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '- ${item['name']} (Qty: ${item['quantity']}) - ${item['price']} K',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Total Amount: ${widget.basket.fold<double>(0.0, (sum, item) => sum + item['price'] * item['quantity'])} K',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'An invoice has been generated and saved for your records.',
                  style: formfieldStyle,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Reset the form and state variables
                  _formKey.currentState?.reset();
                  setState(() {
                    _township = '';
                    _streetAddress = '';
                    _phone = '';
                    _additionalInfo = '';
                    _deliveryMethod = 'Online Payment';
                    _paymentMethod = '';
                    _transactionImage = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      await generateInvoice(orderData, _transactionImage);
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
              // Township input field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Township'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Township';
                  }
                  return null;
                },
                onSaved: (value) {
                  _township = value!;
                },
              ),
              // Street Address input field
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
              // Phone input field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  } else if (value.length != 11) {
                    return 'Phone number must be exactly 11 digits';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),

              // Additional Information input field
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Additional Information'),
                onSaved: (value) {
                  _additionalInfo = value ?? '';
                },
              ),
              const SizedBox(height: 20),

              // Section title for Payment Method
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Payment method options
              _buildPaymentMethodOption(
                  'KPay', 'assets/images/pay.png', '09989662010'),
              _buildPaymentMethodOption(
                  'WavePay', 'assets/images/pay1.png', '09989662010'),
              _buildPaymentMethodOption(
                  'AyaPay', 'assets/images/pay2.png', '09989662010'),
              _buildPaymentMethodOption(
                  'CBPay', 'assets/images/pay3.png', '09989662010'),
              // Display transaction image if available
              if (_transactionImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.file(
                    _transactionImage!,
                    height: 200, // Adjust as needed
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              // Button to pick the transaction image
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickTransactionImage,
                child: const Text('Upload Transaction Image'),
              ),
              const SizedBox(height: 20),

              // Show loading indicator when confirming payment
              if (_isLoading) const Center(child: CircularProgressIndicator()),

               // Confirm Payment button
              if (!_isLoading)
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _saveOrder();
                        },
                  child: const Text('Confirm Payment'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
      String title, String assetPath, String phoneNumber) {
    return ListTile(
      leading: Image.asset(assetPath, width: 40, height: 40),
      title: Text(title),
      subtitle: Text(phoneNumber),
      trailing: Radio<String>(
        value: title,
        groupValue: _paymentMethod,
        onChanged: (String? value) {
          setState(() {
            _paymentMethod = value!;
          });
        },
      ),
    );
  }
}
