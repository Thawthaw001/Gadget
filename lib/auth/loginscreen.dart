import 'package:flutter/material.dart';
import 'package:thaw/Pages/Forgotpassword.dart';
import 'package:thaw/Pages/Homescreen.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/register.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';

import '../utils/validation.dart';

class Login extends StatefulWidget {
  // ignore: use_super_parameters
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _passwordStrength = '';
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  void _checkPasswordStrength(String Password) {
    setState(() {
      _passwordStrength = evaluatePasswordStrength(Password);
    });
  }




  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _login() async {
    final user = await _auth.loginUserWithEmailAndPassword(
        _emailController.text, _passwordController.text);

    if (user != null) {
      // ignore: avoid_print
      print("User Logged In");
      // ignore: use_build_context_synchronously
      goToHome(context);
    }
  }

  _loginWithGoogle() async {
    final userCred = await _auth.loginWithGoogle();
    if (userCred != null) {
      // ignore: use_build_context_synchronously
      goToHome(context);
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
                width:600,
                height: MediaQuery.of(context).size.height /1.5,
                child: SingleChildScrollView(
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
                      Form(
                        child: Column(
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
                              onChanged: _checkPasswordStrength,
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
                            const SizedBox(height: 20),
                            Text(
                              'Password Strength $_passwordStrength',
                              style: TextStyle(
                                fontSize: 18,
                                color: getStrengthColor(_passwordStrength),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            LinearProgressIndicator(
                              value: _passwordStrength == 'Weak'
                                  ? 0.3
                                  : _passwordStrength == 'Medium'
                                      ? 0.6
                                      : _passwordStrength == 'Strong'
                                          ? 1.0
                                          : 0.0,
                              color: getStrengthColor(_passwordStrength),
                              backgroundColor: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
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
                                onPressed: _login,
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
                              FontAwesomeIcons.google,
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
    );
  }
}
