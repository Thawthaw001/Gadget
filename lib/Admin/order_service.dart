// lib/services/order_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  Future<void> createOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required double totalAmount,
    required String cardNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'totalAmount': totalAmount,
      'cardNumber': cardNumber,
      'items': items,
      'orderDate': DateTime.now(),
    });
  }
}
