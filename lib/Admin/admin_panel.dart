// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously, must_be_immutable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaw/Admin/Brand/brand_panel.dart';
import 'package:thaw/Admin/Model/category_model.dart';
import 'package:thaw/Admin/categoryService.dart';
import 'package:thaw/auth/loginscreen.dart';
import '../auth/auth_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final Auth auth = Auth();
  final TextEditingController nameController = TextEditingController();
  File? _image;

  final picker = ImagePicker();

  void _logout() async {
    await auth.signOut(); 

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
      (route) => false,
    );
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _addCategory() async {
    if (nameController.text.isNotEmpty && _image != null) {
      String imageUrl =
          await CatService.uploadImageToStorage(_image!, 'category_image.jpg');

      final newCategory =
          FourCategory(name: nameController.text, imageUrl: imageUrl);

      await CatService.addCategory(newCategory);

      nameController.clear();
      setState(() {
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in all fields and select an image')),
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
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Admin Panel'),
              SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    print('brand');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BrandPage()));
                  },
                  icon: Icon(Icons.branding_watermark_sharp)),
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
              _image != null
                  ? Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : SizedBox.shrink(),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () => _addCategory(),
                child: Text('Add Category'),
              ),
            ],
          ),
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
