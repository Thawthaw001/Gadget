// ignore_for_file: unused_import, unused_local_variable, avoid_print

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:thaw/Admin/admin_panel.dart';
import 'package:thaw/Pages/Forgotpassword.dart';
import 'package:thaw/Pages/homePage.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/register.dart';
import 'package:thaw/models/UserData.dart';
import 'package:thaw/models/userData.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';
import 'package:thaw/utils/form_validation.dart';
import 'package:thaw/utils/sharepreferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  goToAdmin() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPanel()),
      );

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register()),
      );

  goToHome() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  Future<void> _login() async {
    try {
       print(
            "Login User name is ${_emailController.text} and pass is ${_passwordController.text}");
      await Auth()
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((_) async {
       print("Reach here");
        var loginUser =
            await Auth().getUserRole(_emailController.text.toString());
        print("Login User is $loginUser ");
        if (loginUser != null) {
          var userRole = loginUser.role;

          await SharePreferenceService.saveUserRole(userRole);

          print("User role is $userRole");
          if (userRole == "admin") {
            goToAdmin();
          } else {
            goToHome();
          }
        }
        return null;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  _loginWithGoogle() async {
    final UserCredential? userCredential = await Auth().loginWithGoogle();
    if (userCredential != null) {
      goToHome();
    } else {
      print("Google sign-in was not successful. UserCredential is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getDecoration(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 600,
                height: MediaQuery.of(context).size.height / 1.8,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: "English",
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 130),
                                child: Image.asset(
                                  'assets/images/Generate_a_logo_75f1e5eb-f843-4e71-a763-daf800aa47e0-removebg-preview.png', // Replace with your logo URL
                                  width: 70,
                                  height: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: formfieldStyle,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscured,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: formfieldStyle,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: _togglePasswordVisibility,
                                      icon: Icon(
                                        _isObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: _isObscured
                                            ? Colors.grey
                                            : Colors.black,
                                      ))),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const ForgotPassword()));
                                },
                                child: Text('Forget Password',
                                    style: formfieldStyle),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    goToSignup(context);
                                  },
                                  child:
                                      Text('Register', style: formfieldStyle),
                                )),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    print("HEeeehhe ");
                                    _login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Makes it rounded
                                  ),
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          20), // Button background color
                                ),
                                icon: const Icon(
                                  Icons.login,
                                  size: 20,
                                  color: Colors.lightBlueAccent,
                                ),
                                label: Text(
                                  'Login',
                                  style: formfieldStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                              onPressed: _loginWithGoogle,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // Makes it rounded
                                ),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20), // Button background color
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.squareGooglePlus,
                                size: 16,
                                color: Colors.lightBlueAccent,
                              ),
                              label: Text('Google', style: formfieldStyle)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
