// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously, must_be_immutable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaw/Admin/Brand/Edit%20&%20Delete%20brand%20,%20model/edit_delete_brandmodel.dart';
import 'package:thaw/Admin/Brand/brand_panel.dart';
import 'package:thaw/Admin/Model/category_model.dart';
import 'package:thaw/Admin/categoryService.dart';
import 'package:thaw/auth/loginscreen.dart';
import 'package:thaw/utils/decoration.dart';
import 'package:thaw/utils/formfield.dart';
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
        title: Text('Gadget Max\'s Admin Panel', style: formfieldStyle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: Container(
        decoration: getDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Brand Control',
                style: formfieldStyle,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BrandPage()));
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Go to Brand Page'),
                    SizedBox(width: 8),
                    Image.asset('assets/images/brand-removebg-preview.png',
                        height: 24)
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Type Category Name',
                    filled: true,
                    fillColor: Color(0xFFFFDFE5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Container(
                  color: Color(0xFFFFFFFF),
                  height: 150,
                  width: 150,
                  child: _image == null
                      ? Center(child: Text('Pick Image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addCategory(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFDFE5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Add Category'),
              ),
              SizedBox(height: 10),
              Text('View added brand & model', style: formfieldStyle),
              SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditDeleteBrandModel()));
                },
                icon: Icon(FontAwesomeIcons.arrowRight),
              )
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
