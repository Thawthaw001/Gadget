// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key});

  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final TextEditingController nameController = TextEditingController();
  File? _image;

  // Function to pick an image from gallery
  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload category data to Firestore
  Future<void> _addCategory() async {
    String categoryName = nameController.text.trim();

    // Ensure both name and image are provided
    if (categoryName.isNotEmpty && _image != null) {
      try {
        // Upload image to Firebase Storage
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('category_images/$imageName.jpg');
        await ref.putFile(_image!);
        String imageUrl = await ref.getDownloadURL();

        // Save category data to Firestore
        await FirebaseFirestore.instance.collection('categories').add({
          'name': categoryName,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added successfully')),
        );

        // Clear form fields
        nameController.clear();
        setState(() {
          _image = null;
        });
      } catch (e) {
        // Handle errors
        print('Error adding category: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter category name and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 146, 119, 128),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 300,
                  width: 100,
                  child: _image == null
                      ? const Center(child: Text('Pick Image'))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCategory,
                child: const Text(
                  'Add Category',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AddCategoryForm(),
  ));
}
