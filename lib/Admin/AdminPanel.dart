// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:thaw/Admin/Model/categoryModel.dart';
import 'package:thaw/Admin/categoryService.dart';
import 'package:thaw/auth/loginscreen.dart';
import '../auth/auth_service.dart';

class AdminPanel extends StatelessWidget {
  final CatService categoryService = CatService();
  final Auth auth = Auth();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  List<FourCategory> categories = [];

  AdminPanel({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await auth.signOut(); // Call your signOut method from AuthService

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Login()), // Replace with your login screen widget
      (route) => false, // This will remove all routes below the login screen
    );
  }

  void _addCategory(BuildContext context) async {
    final String name = nameController.text;
    final String imageUrl = imageUrlController.text;

    if (name.isNotEmpty && imageUrl.isNotEmpty) {
      final FourCategory newCategory = FourCategory(name: name, imageUrl: imageUrl);
      await categoryService.addCategory(newCategory);

      // Clear the text fields
      nameController.clear();
      imageUrlController.clear();

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category added successfully!')),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Call _logout method on button press
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Admin Panel'),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _addCategory(context),
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: AdminPanel(),
  ));
}
