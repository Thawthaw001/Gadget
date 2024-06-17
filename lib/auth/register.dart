import 'package:flutter/material.dart';
import 'package:thaw/Pages/Homescreen.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/validation.dart';

import '../utils/formfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  String _passwordStrength = '';
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      _passwordStrength = evaluatePasswordStrength(password);
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasMinLength = password.length >= 8;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _signUp() async {
    final user = await _auth.createUserWithEmailAndPassword(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      // ignore: avoid_print
      print("User Created Successfully");
      // ignore: use_build_context_synchronously
      goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.arrow_back_ios))),
      body: Container(
        decoration: getDecoration(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 0.7,
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
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontFamily: "English",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 130),
                              child: Image.asset(
                                'assets/images/Generate_a_logo_75f1e5eb-f843-4e71-a763-daf800aa47e0-removebg-preview.png', // Replace with your logo URL
                                width: 60,
                                height: 70,
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
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: "Username",
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
                            const SizedBox(height: 10),
                            Text(
                              'Password Strength: $_passwordStrength',
                              style: TextStyle(
                                fontSize: 18,
                                color: getStrengthColor(_passwordStrength),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: _passwordStrength == 'Weak'
                                  ? 0.3
                                  : _passwordStrength == 'Medium'
                                      ? 0.6
                                      : _passwordStrength == 'Strong'
                                          ? 1.0
                                          : 0.0,
                              color: getStrengthColor(_passwordStrength),
                              backgroundColor: Colors.grey[300],
                            ),
                            Text('Password must include:',
                                style: formfieldStyle),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  _hasUppercase ? Icons.check : Icons.close,
                                  color:
                                      _hasUppercase ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'At least one uppercase letter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _hasUppercase
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  _hasNumber ? Icons.check : Icons.close,
                                  color: _hasNumber ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'At least one number',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _hasNumber ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height:10),
                            Row(
                              children: [
                                Icon(
                                  _hasMinLength ? Icons.check : Icons.close,
                                  color:
                                      _hasMinLength ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'At least 8 characters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _hasMinLength
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: _signUp,
                              child: Text('Register', style: formfieldStyle),
                            ),
                          ],
                        ),
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
