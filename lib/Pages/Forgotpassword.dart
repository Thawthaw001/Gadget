import 'package:flutter/material.dart';
import 'package:thaw/Widget/button.dart';
import 'package:thaw/Widget/textfield.dart';
import 'package:thaw/auth/auth_service.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter Email to send you a reset password'),
            const SizedBox(height: 20),
            CustomTextField(
              hint: 'Enter Email',
              label: 'Email',
              
              controller: emailController,
            ),
            const SizedBox(height: 20), // Add some space between the text field and button
            CustomButton(
              label: "Send Reset Link",
              onPressed: () async {
                try {
                  await auth.sendPasswordResetLink(emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "An email for password reset has been sent to your email",
                    ),
                  ));
                  Navigator.pop(context);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Failed to send reset email: $error"),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

 
