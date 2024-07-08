// ignore: depend_on_referenced_packages
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Admin/Brand/brand_panel.dart';
import 'package:thaw/Admin/Brand/brandmodel_panel.dart';
// import 'package:thaw/Admin/Model/categoryModel.dart';
// import 'package:thaw/Admin/categoryService.dart';
import 'package:thaw/Pages/homePage.dart';
import 'package:thaw/auth/auth_Splashscreen.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme:
        ThemeData(primarySwatch: Colors.blueGrey, brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
    home: SplashScreen(),
    routes: {
      "/login": (context) => const Login(),
      "/register": (context) => const Register(),
      "/home": (context) => const HomeScreen(),
      "/brand": (context) => const BrandPage(),
      "/brandmodelpanel": (context) => const BrandModelPage()
      // "/forgotpassword": (context) => const ForgotPassword(),
    },
  ));
}
