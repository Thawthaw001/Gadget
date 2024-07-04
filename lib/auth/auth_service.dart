// ignore_for_file: avoid_print, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thaw/auth/auth_firestore.dart';
import 'package:thaw/models/userData.dart';

class Auth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currenUser => _firebaseAuth.currentUser;

  Stream<User?> get authStageChanges => _firebaseAuth.authStateChanges();

  // ignore: body_might_complete_normally_nullable
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sin in error is $e');
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      // Set locale before starting the sign-in process
      _auth.setLanguageCode('en'); // Set this to the desired locale

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If the user cancels the sign-in process
        print("Google sign-in canceled by user");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(cred);

      final User? user = userCredential.user;
      if (user != null) {
        await AuthStore().addUserToFirestore(
          userId: user.uid,
          name: user.displayName ?? 'No Name',
          email: user.email ?? 'No Email',
        );
      }

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password,
      required String role}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (currenUser != null) {
        AuthStore().addUserToFirestore(
            userId: currenUser!.uid, name: name, email: email, role: role);
      } else {
        print('currenUser$currenUser');
      }
    } catch (error) {
      print("Sign up error $error");
      rethrow;
    }
  }

  Future<String> getUserName() async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final String uid = _firebaseAuth.currentUser!.uid;

      final result = await users.doc(uid).get();

      final Map<String, dynamic>? data = result.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('name')) {
        return data['name'].toString();
      } else {
        throw Exception("Display name not found in Firestore data");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Signout");

      //  await GoogleSignIn().signOut();
    } catch (e) {
      print("Signout error $e");
    }
  }

  Future<UserData?> getUserRole(String userEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo:userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs[0].data();
        return UserData(email:data['email'], name:'', role:data['role']);
      } else {
        print('User not found in Firestore');
        return null;
      }
    } catch (error) {
      print('Error retrieving user data: $error');
      return null;
    }
  }
}
