// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> createUserWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('cred $cred');
      return cred.user;
    } catch (e) {
      // ignore: avoid_print
      print('Something worng $e');
    }
    return null;
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print('Something wrong $e');
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong" as num);
    }
  }
}
