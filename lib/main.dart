// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/Forgotpassword.dart';
import 'package:thaw/Pages/Homescreen.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => const Login(),
      "/register": (context) => const Register(),
      "/home": (context) => const HomeScreen(),
      "/forgotpassword":(context) => const ForgotPassword()
    },
  ));
}
