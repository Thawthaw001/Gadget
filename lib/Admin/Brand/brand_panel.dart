import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thaw/Admin/Brand/brand_service.dart';
import 'package:thaw/Admin/Brand/model/brand_class.dart';
import 'package:thaw/Admin/Brand/model/brand_model.dart';
import 'package:thaw/Admin/Widget/custom_tag.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  BrandPageState createState() => BrandPageState();
}

class BrandPageState extends State<BrandPage> {
  String selectedCategoryId = '';
  String selectedBrandId = '';
  List<DropdownMenuItem<String>> categoryItems = [];
  List<DropdownMenuItem<String>> brandItems = [];
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController brandImageController = TextEditingController();
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController specsController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  List<String> selectedColors = [];
  List<String> selectedStorageOptions = [];
  List<File>? _images = [];
  File? _brandImage;
  final ImagePicker _picker = ImagePicker();
  bool isBrandInStock = true;
  bool isModelInStock = true;

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
                child: Text(doc['name'] ?? 'No name'),
              ))
          .toList();
    });
  }

  Future<void> pickImage({required bool isBrandImage}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isBrandImage) {
          _brandImage = File(pickedFile.path);
        } else {
          _images = [File(pickedFile.path)];
        }
      });
    }
  }

  Future<void> pickMultipleImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
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

  Future<List<String>> uploadImagesToStorage(List<File> imageFiles) async {
    List<String> downloadUrls = [];

    for (var imageFile in imageFiles) {
      String? downloadUrl = await uploadImageToStorage(imageFile);
      if (downloadUrl != null) {
        downloadUrls.add(downloadUrl);
      }
    }

    return downloadUrls;
  }

  Future<void> addBrand() async {
    if (selectedCategoryId.isNotEmpty && brandNameController.text.isNotEmpty) {
      String? imageUrl;

      if (_brandImage != null) {
        imageUrl = await uploadImageToStorage(_brandImage!);
      }

      Brand newBrand = Brand(
        name: brandNameController.text,
        imageUrl: imageUrl ?? 'default_image_url_here',
        quantity: 10,
        colors: [],
        storageOptions: [],
        inStock: isBrandInStock, // Include stock status
      );

      await BrandService().addBrand(selectedCategoryId, newBrand);

      brandNameController.clear();
      setState(() {
        _brandImage = null;
      });

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
    if (selectedCategoryId.isNotEmpty &&
        selectedBrandId.isNotEmpty &&
        modelNameController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        specsController.text.trim().isNotEmpty &&
        quantityController.text.trim().isNotEmpty) {
      List<String> imageUrls = [];

      if (_images != null && _images!.isNotEmpty) {
        imageUrls = await uploadImagesToStorage(_images!);
      }

      Model newModel = Model(
        name: modelNameController.text.trim(),
        price: double.parse(priceController.text.trim()),
        specs: specsController.text.trim(),
        imageUrls: imageUrls,
        colors: selectedColors,
        storageOptions: selectedStorageOptions,
        quantity: int.parse(quantityController.text.trim()),
        inStock: isModelInStock, // Include stock status
      );

      await BrandService()
          .addModel(selectedCategoryId, selectedBrandId, newModel);

      modelNameController.clear();
      priceController.clear();
      specsController.clear();
      quantityController.clear();
      setState(() {
        _images = [];
        selectedColors = [];
        selectedStorageOptions = [];
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
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => pickImage(isBrandImage: true),
                child: Container(
                  color: Colors.grey[200],
                  height: 150,
                  width: double.infinity,
                  child: _brandImage != null
                      ? Image.file(_brandImage!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo, size: 50),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('In Stock'),
                  Switch(
                    value: isBrandInStock,
                    onChanged: (bool value) {
                      setState(() {
                        isBrandInStock = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: specsController,
                decoration: const InputDecoration(labelText: 'Specifications'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomTagInput(
                tags: selectedColors,
                labelText: 'Colors',
                hintText: 'Enter a color and press enter',
                onTagsChanged: (tags) {
                  setState(() {
                    selectedColors = tags;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              CustomTagInput(
                tags: selectedStorageOptions,
                labelText: 'Storage Options',
                hintText: 'Enter a storage option and press enter',
                onTagsChanged: (tags) {
                  setState(() {
                    selectedStorageOptions = tags;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: pickMultipleImages,
                child: Container(
                  color: Colors.grey[200],
                  height: 150,
                  width: double.infinity,
                  child: _images != null && _images!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(_images![index],
                                  fit: BoxFit.cover),
                            );
                          },
                        )
                      : const Icon(Icons.add_a_photo, size: 50),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('In Stock'),
                  Switch(
                    value: isModelInStock,
                    onChanged: (bool value) {
                      setState(() {
                        isModelInStock = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
