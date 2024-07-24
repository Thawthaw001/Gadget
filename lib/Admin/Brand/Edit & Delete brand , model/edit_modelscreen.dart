import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditModelScreen extends StatefulWidget {
  final String categoryId;
  final String brandId;
  final String modelId;

  const EditModelScreen({
    super.key,
    required this.categoryId,
    required this.brandId,
    required this.modelId,
  });

  @override
  State<EditModelScreen> createState() => _EditModelScreenState();
}

class _EditModelScreenState extends State<EditModelScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _specsController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    fetchModelDetails();
  }

  Future<void> fetchModelDetails() async {
    try {
      final DocumentSnapshot result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('brands')
          .doc(widget.brandId)
          .collection('models')
          .doc(widget.modelId)
          .get();

      if (result.exists) {
        setState(() {
          _nameController = TextEditingController(text: result['name']);
          _priceController =
              TextEditingController(text: result['price'].toString());
          _specsController = TextEditingController(text: result['specs']);
          _imageController = TextEditingController(text: result['imageUrl']);
        });
      }
    } catch (e) {
      print('Error fetching model details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Model'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Model Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specsController,
                decoration: const InputDecoration(labelText: 'Specs'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specs';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateModel();
                  }
                },
                child: const Text('Update Model'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateModel() async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('brands')
          .doc(widget.brandId)
          .collection('models')
          .doc(widget.modelId)
          .update({
        'name': _nameController.text,
        'price': int.parse(_priceController.text),
        'specs': _specsController.text,
        'imageUrl': _imageController.text,
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error updating model: $e');
    }
  }
}
