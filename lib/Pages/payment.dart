import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thaw/Pages/pdf_invoice.dart'; // Ensure this import is correct

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> basket;

  const PaymentPage({super.key, required this.basket});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String _state = '';
  String _township = '';
  String _streetAddress = '';
  String _phone = '';
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
                  if (value == null || value.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Additional Information'),
                onSaved: (value) {
                  _additionalInfo = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    final orderData = {
                      'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
                      'orderDate': DateTime.now().toString(),
                      'userId': _userId,
                      'userName': _userName,
                      'userEmail': _userEmail,
                      'state': _state,
                      'township': _township,
                      'streetAddress': _streetAddress,
                      'phone': _phone,
                      'additionalInfo': _additionalInfo,
                      'items': widget.basket,
                      'totalAmount': widget.basket.fold<double>(
                        0.0,
                        (sum, item) => sum + item['price'] * item['quantity'],
                      ),
                    };

                    // Pass orderData to generate the PDF
                    generateInvoice(orderData);

                    // Navigate to the confirmation page or show a success message
                    Navigator.pop(context);
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
