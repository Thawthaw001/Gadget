import 'package:cloud_firestore/cloud_firestore.dart';

class AuthStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//to add user to firestore
  Future<void> addUserToFirestore(
      {required String userId,
      required String name,
      required String email,
      String role = 'user'}) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set({'name': name, 'email': email, 'role': role});

      // logger.e("Register success");
      //print("Successful user adding to firestore.");
    } catch (error) {
      // logger.e("Register fail $error");
      //print('Error adding user data to Firestore: $error');
      rethrow;
    }
  }

  // Method to get user role from Firestore
  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot['role'] as String?;
      }
    } catch (error) {
      //print('Error fetching user role: $error');
      rethrow;
    }
    return null;
  }
}
