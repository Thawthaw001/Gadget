import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BrandModelPage extends StatefulWidget {
  const BrandModelPage({Key? key}) : super(key: key);

  @override
  _BrandModelPageState createState() => _BrandModelPageState();
}

class _BrandModelPageState extends State<BrandModelPage> {
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specsController = TextEditingController();
  late FirebaseFirestore firestore;
  late CollectionReference categoriesRef;
  String selectedCategoryId = '';
  String selectedBrandId = '';
  List<DropdownMenuItem<String>> categoryItems = [];
  List<DropdownMenuItem<String>> brandItems = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    categoriesRef = firestore.collection('categories');
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final QuerySnapshot result = await categoriesRef.get();
    final List<DocumentSnapshot> documents = result.docs;

    setState(() {
      categoryItems = documents
          .map((doc) => DropdownMenuItem<String>(
                value: doc.id,
                child: Text(doc['name']),
              ))
          .toList();
    });
  }

  Future<void> fetchBrands(String categoryId) async {
    final QuerySnapshot result =
        await categoriesRef.doc(categoryId).collection('brands').get();
    final List<DocumentSnapshot> documents = result.docs;

    setState(() {
      brandItems = documents
          .map((doc) => DropdownMenuItem<String>(
                value: doc.id,
                child: Text(doc['name']),
              ))
          .toList();
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = 'models/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  void addModel() async {
    String modelName = modelNameController.text.trim();
    String price = priceController.text.trim();
    String specs = specsController.text.trim();

    if (selectedCategoryId.isNotEmpty &&
        selectedBrandId.isNotEmpty &&
        modelName.isNotEmpty &&
        price.isNotEmpty &&
        specs.isNotEmpty) {
      String? imageUrl;

      if (_image != null) {
        imageUrl = await uploadImageToStorage(_image!);
      }

      if (imageUrl != null) {
        CollectionReference modelsRef = categoriesRef
            .doc(selectedCategoryId)
            .collection('brands')
            .doc(selectedBrandId)
            .collection('models');

        modelsRef.add({
          'name': modelName,
          'price': price,
          'specs': specs,
          'image': imageUrl,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Model added successfully!')),
          );
          modelNameController.clear();
          priceController.clear();
          specsController.clear();
          setState(() {
            _image = null;
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add model: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                hint: const Text('Select Category'),
                items: categoryItems,
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value!;
                    selectedBrandId = ''; // Reset selected brand when category changes
                    fetchBrands(selectedCategoryId);
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedBrandId.isEmpty ? null : selectedBrandId,
                hint: const Text('Select Brand'),
                items: brandItems,
                onChanged: (value) {
                  setState(() {
                    selectedBrandId = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: modelNameController,
                decoration: const InputDecoration(
                  labelText: 'Model Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: specsController,
                decoration: const InputDecoration(
                  labelText: 'Specifications',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? Image.file(_image!, height: 150, width: 150)
                  : const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addModel,
                child: const Text('Add Model'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}