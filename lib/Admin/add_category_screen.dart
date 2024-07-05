// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thaw/Admin/Model/category_model.dart';
import 'package:thaw/Admin/categoryService.dart';

class AddCategoryScreen extends StatefulWidget {

  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _imageController = TextEditingController();


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  File? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    final category =
                        FourCategory(name: _nameController.text, imageUrl: '');
                    await CatService.addCategory(category);
                    _nameController.clear();
                    _imageController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Category added successfully')),
                    );
                  }
                },
                child: const Text('Add Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
