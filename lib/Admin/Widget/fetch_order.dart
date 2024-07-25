import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<Map<String, dynamic>>> fetchUserOrders() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    QuerySnapshot<Map<String, dynamic>> orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: currentUser.uid)
        .get();
    
    return orderSnapshot.docs.map((doc) => doc.data()).toList();
  } else {
    throw Exception("User not logged in");
  }
}
