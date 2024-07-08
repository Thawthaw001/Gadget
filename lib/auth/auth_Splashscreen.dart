// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thaw/Admin/admin_panel.dart';
import 'package:thaw/Pages/homePage.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/sharepreferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userRole;
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    String? role = await SharePreferenceService.getUseRole();


print("Sharepref role is $role");
    setState(() {
      userRole = role;
    });

    if (userRole != null && userRole!.isNotEmpty) {
      print("Splash Scren in role is $userRole");
      if (userRole!.contains("admin")) {
        print("User role form splash screen is $userRole");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminPanel()),
        );
      } else {
        print("Else blok User role form splash screen is $userRole");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      print("Login Page Screen");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/images/Generate_a_logo_75f1e5eb-f843-4e71-a763-daf800aa47e0-removebg-preview.png',
                width: 200,
                height: 200), // Replace with your logo
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
