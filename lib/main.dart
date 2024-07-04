// ignore: depend_on_referenced_packages
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thaw/Admin/Model/categoryModel.dart';
// import 'package:thaw/Admin/Model/categoryModel.dart';
// import 'package:thaw/Admin/categoryService.dart';
import 'package:thaw/Pages/homePage.dart';
import 'package:thaw/Services/firebase_storage_service.dart';
import 'package:thaw/auth/auth_Splashscreen.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/auth/register.dart';

import 'Admin/categoryService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  Get.lazyPut(() => FirebaseStorageService());
  final CatService categoryService = CatService();

  List<FourCategory> categories = [
    FourCategory(name: '', imageUrl: ''),
  ];
  //Add each cat to Firestore
  for (FourCategory category in categories) {
    await categoryService.addCategory(category);
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: SplashScreen(),
    routes: {
      "/login": (context) => const Login(),
      "/register": (context) => const Register(),
      "/home": (context) => const HomeScreen(),
      // "/forgotpassword": (context) => const ForgotPassword(),
    },
  ));
}
