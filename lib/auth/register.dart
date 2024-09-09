// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:thaw/Pages/home_page.dart';
import 'package:thaw/auth/auth_service.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/form_validation.dart';
import 'package:thaw/utils/PasswordStrength.dart';
import 'package:thaw/utils/dynamic_textform.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';
import 'package:thaw/utils/linear_progress_indicator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  String _passwordStrength = '';
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

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

  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _signUp() async {
    final name = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await Auth().createUserWithEmailAndPassword(
        name: name, email: email, password: password, role: 'user');

    goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Register", style: formfieldStyle),
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
                        key: _formKey,
                        child: Column(
                          children: [
                            GadgeTextFormField(
                              controller: _usernameController,
                              focusNode: _nameFocus,
                              hintText: 'User Name',
                              keyboardType: TextInputType.name,
                              validator: FormValidator.validateName,
                            ),
                            const SizedBox(height: 20),
                            GadgeTextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (!FormValidator.isEmailValid(value!)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            GadgeTextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              hintText: 'Password',
                              keyboardType: TextInputType.text,
                              obscureText: _isObscured,
                              validator: (String? value) {
                                _checkPasswordStrength(value ?? '');
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color:
                                      _isObscured ? Colors.grey : Colors.black,
                                ),
                              ),
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
                            const Indicator(),
                            const SizedBox(height: 10),
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
                            const SizedBox(height: 10),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signUp();
                                }
                              },
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
