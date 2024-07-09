import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaw/Admin/Brand/Edit%20&%20Delete%20brand%20,%20model/edit_modelscreen.dart';

class EditDeleteBrandModel extends StatefulWidget {
  const EditDeleteBrandModel({super.key});

  @override
  State<EditDeleteBrandModel> createState() => _EditDeleteBrandModelState();
}

class _EditDeleteBrandModelState extends State<EditDeleteBrandModel> {
  String selectedCategoryId = '';
  String selectedBrandId = '';
  String selectedModelId = '';

  List<DocumentSnapshot> categories = [];
  List<DocumentSnapshot> brands = [];
  List<DocumentSnapshot> models = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    print(categories);
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = result.docs;
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.id;
          fetchBrands(selectedCategoryId);
        } else {
          print('No categories found');
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchBrands(String categoryId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .get();
      setState(() {
        brands = result.docs;
        if (brands.isNotEmpty) {
          selectedBrandId = brands.first.id;
          fetchModels(selectedCategoryId, selectedBrandId);
        } else {
          print('No brands found for category $categoryId');
        }
      });
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  Future<void> fetchModels(String categoryId, String brandId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .doc(brandId)
          .collection('models')
          .get();
      setState(() {
        models = result.docs;
        if (models.isNotEmpty) {
          selectedModelId = models.first.id;
        } else {
          print('No models found for brand $brandId');
        }
      });
    } catch (e) {
      print('Error fetching models: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit & Delete Brand and Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value!;
                    selectedBrandId = '';
                    selectedModelId = '';
                    brands.clear();
                    models.clear();
                    fetchBrands(selectedCategoryId);
                  });
                },
              ),
              DropdownButton<String>(
                hint: const Text('Select Brand'),
                value: selectedBrandId.isEmpty ? null : selectedBrandId,
                items: brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand.id,
                    child: Text(brand['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBrandId = value!;
                    selectedModelId = '';
                    models.clear();
                    fetchModels(selectedCategoryId, selectedBrandId);
                  });
                },
              ),
              DropdownButton<String>(
                hint: const Text('Select Model'),
                value: selectedModelId.isEmpty ? null : selectedModelId,
                items: models.map((model) {
                  return DropdownMenuItem<String>(
                    value: model.id,
                    child: Text(model['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedModelId = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedCategoryId.isNotEmpty &&
                      selectedBrandId.isNotEmpty &&
                      selectedModelId.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditModelScreen(
                          categoryId: selectedCategoryId,
                          brandId: selectedBrandId,
                          modelId: selectedModelId,
                        ),
                      ),
                    );
                    print(
                        "Edit Model are $selectedCategoryId && $selectedBrandId && $selectedModelId");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please select a category, brand, and model')),
                    );
                  }
                },
                child: const Text('Edit Model'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
