// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaw/Admin/Brand/brand_service.dart';
import 'package:thaw/Admin/Brand/model/brand_class.dart';
import 'package:thaw/Admin/Brand/model/brand_model.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  String selectedCategoryId = '';
  String selectedBrandId = '';
  List<DropdownMenuItem<String>> categoryItems = [];
  List<DropdownMenuItem<String>> brandItems = [];
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specsController = TextEditingController();
  final TextEditingController storageOptionsController =
      TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(); // Add this line
  bool inStock = false;
  List<String> selectedColors = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('categories').get();
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
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('brands')
        .get();
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

  Future<void> addBrand() async {
    if (selectedCategoryId.isNotEmpty && brandNameController.text.isNotEmpty) {
      List<String> colors = selectedColors.isNotEmpty
          ? List.from(selectedColors)
          : [''];  
      List<String> storageOptions = storageOptionsController.text.isNotEmpty
          ? storageOptionsController.text.split(',')
          : ['']; 
      Brand newBrand = Brand(
          name: brandNameController.text,
          imageUrl: 'your_image_url_here',
          colors: colors,
          storageOptions: storageOptions,
          inStock: inStock,
           quantity: 0 // Default quantity for brand, update as necessary
          );

      await BrandService().addBrand(selectedCategoryId, newBrand);

      brandNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand added successfully!')),
      );

      fetchBrands(selectedCategoryId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a category and enter a brand name')),
      );
    }
  }

  void addModel() async {
    String modelName = modelNameController.text.trim();
    double price = double.parse(priceController.text.trim());
    String specs = specsController.text.trim();
    List<String> colors = selectedColors.isNotEmpty
        ? List.from(selectedColors)
        : ['']; // Example colors list
    List<String> storageOptions = storageOptionsController.text.isNotEmpty
        ? storageOptionsController.text.split(',')
        : ['']; // Example storage options list
    int quantity = int.parse(quantityController.text.trim()); // Add this line

    if (selectedCategoryId.isNotEmpty &&
        selectedBrandId.isNotEmpty &&
        modelName.isNotEmpty &&
        price.toString().isNotEmpty &&
        specs.isNotEmpty &&
        quantityController.text.isNotEmpty) {
      // Ensure quantity is also filled
      String? imageUrl;

      if (_image != null) {
        imageUrl = await uploadImageToStorage(_image!);
      }

      Model newModel = Model(
        name: modelName,
        price: price,
        specs: specs,
        imageUrl: imageUrl ?? 'default_image_url_here',
        colors: colors,
        storageOptions: storageOptions,
        inStock: inStock,
        quantity: quantity, // Add this line
      );

      await BrandService()
          .addModel(selectedCategoryId, selectedBrandId, newModel);

      modelNameController.clear();
      priceController.clear();
      specsController.clear();
      storageOptionsController.clear();
      quantityController.clear(); // Clear quantity controller
      setState(() {
        _image = null;
        selectedColors = [];
        inStock = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model added successfully!')),
      );
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
        title: const Text('Brand Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Select a Category'),
                value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                items: categoryItems,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoryId = newValue!;
                    fetchBrands(selectedCategoryId);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: brandNameController,
                decoration: const InputDecoration(labelText: 'Brand Name'),
              ),
              ElevatedButton(
                onPressed: addBrand,
                child: const Text('Add Brand'),
              ),
              const SizedBox(height: 20),
              if (selectedCategoryId.isNotEmpty)
                DropdownButtonFormField<String>(
                  hint: const Text('Select a Brand'),
                  value: selectedBrandId.isEmpty ? null : selectedBrandId,
                  items: brandItems,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBrandId = newValue!;
                    });
                  },
                ),
              const SizedBox(height: 16.0),
              TextField(
                controller: modelNameController,
                decoration: const InputDecoration(labelText: 'Model Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: specsController,
                decoration: const InputDecoration(labelText: 'Specifications'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: storageOptionsController,
                decoration: const InputDecoration(labelText: 'Storage Options'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: quantityController, // Add this line
                decoration: const InputDecoration(
                    labelText: 'Quantity'), // Add this line
              ),
              const SizedBox(height: 16.0),
              CheckboxListTile(
                title: const Text('In Stock'),
                value: inStock,
                onChanged: (bool? value) {
                  setState(() {
                    inStock = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
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
