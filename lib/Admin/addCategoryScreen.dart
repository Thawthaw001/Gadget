// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:thaw/Admin/Model/categoryModel.dart';
import 'package:thaw/Admin/categoryService.dart';

class addCategoryScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final CatService categoryService = CatService();
  addCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:const Text('Add Category')),
      body:Padding(padding: const EdgeInsets.all(16),
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
                final name = _nameController.text;
                final imageUrl = _imageController.text;
                if (name.isNotEmpty && imageUrl.isNotEmpty) {
                  final category = FourCategory(name: name, imageUrl: imageUrl);
                  await categoryService.addCategory(category);
                  _nameController.clear();
                  _imageController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Add Category'),
            ),
        ],
      ),),
      
    );
  }
}
