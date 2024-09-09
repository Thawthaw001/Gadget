// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditModelScreen extends StatefulWidget {
//   final String categoryId;
//   final String brandId;
//   final String modelId;

//   const EditModelScreen({
//     super.key,
//     required this.categoryId,
//     required this.brandId,
//     required this.modelId,
//   });

//   @override
//   State<EditModelScreen> createState() => _EditModelScreenState();
// }

// class _EditModelScreenState extends State<EditModelScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _priceController;
//   late TextEditingController _specsController;
//   late TextEditingController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     fetchModelDetails();
//   }

//   Future<void> fetchModelDetails() async {
//     try {
//       final DocumentSnapshot result = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(widget.categoryId)
//           .collection('brands')
//           .doc(widget.brandId)
//           .collection('models')
//           .doc(widget.modelId)
//           .get();

//       if (result.exists) {
//         setState(() {
//           _nameController = TextEditingController(text: result['name']);
//           _priceController =
//               TextEditingController(text: result['price'].toString());
//           _specsController = TextEditingController(text: result['specs']);
//           _imageController = TextEditingController(text: result['imageUrl']);
//         });
//       }
//     } catch (e) {
//       print('Error fetching model details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Model'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Model Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a price';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _specsController,
//                 decoration: const InputDecoration(labelText: 'Specs'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter specs';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _imageController,
//                 decoration: const InputDecoration(labelText: 'Image URL'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an image URL';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     updateModel();
//                   }
//                 },
//                 child: const Text('Update Model'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> updateModel() async {
// try {
//   await FirebaseFirestore.instance
//       .collection('categories')
//       .doc(widget.categoryId)
//       .collection('brands')
//       .doc(widget.brandId)
//       .collection('models')
//       .doc(widget.modelId)
//       .update({
//     'name': _nameController.text,
//     'price': int.parse(_priceController.text),
//     'specs': _specsController.text,
//     'imageUrl': _imageController.text,
//   });
//   Navigator.pop(context);
// } catch (e) {
//   print('Error updating model: $e');
// }
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  late TextEditingController _colorController;
  late TextEditingController _storageController;
  List<File?> _pickedImages = []; // Store picked images
  List<String> _existingImageUrls = []; // Store existing image URLs

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
          _nameController = TextEditingController(text: result['name'] ?? '');
          _priceController =
              TextEditingController(text: (result['price'] ?? 0).toString());
          _specsController = TextEditingController(text: result['specs'] ?? '');
          _colorController = TextEditingController(
              text: (result['colors'] ?? [])
                  .join(", ")); // Default to empty list if not present
          _storageController = TextEditingController(
              text: (result['storageOptions'] ?? [])
                  .join(", ")); // Default to empty list if not present
          _existingImageUrls = List<String>.from(result['imageUrls'] ?? []);
          _pickedImages = List<File?>.filled(
              _existingImageUrls.length, null); // Initialize with nulls
        });
      }
    } catch (e) {
      print('Error fetching model details: $e');
    }
  }

  Future<void> pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImages[index] = File(image.path);
      });
    }
  }

  Future<void> updateModel() async {
    try {
      List<String> updatedImageUrls = [];

      // Upload or keep existing images
      for (int i = 0; i < _pickedImages.length; i++) {
        if (_pickedImages[i] != null) {
          String fileName =
              '${widget.categoryId}_${widget.brandId}_${widget.modelId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('model_images')
              .child(fileName);
          UploadTask uploadTask = storageRef.putFile(_pickedImages[i]!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          updatedImageUrls.add(downloadUrl);
        } else {
          updatedImageUrls
              .add(_existingImageUrls[i]); // Keep the existing image URL
        }
      }

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('brands')
          .doc(widget.brandId)
          .collection('models')
          .doc(widget.modelId)
          .update({
        'name': _nameController.text,
        'price':
            double.parse(_priceController.text.trim()), // Changed to double
        'specs': _specsController.text,
        'colors': _colorController.text
            .split(',')
            .map((e) => e.trim())
            .toList(), // Convert comma-separated string to list
        'storageOptions': _storageController.text
            .split(',')
            .map((e) => e.trim())
            .toList(), // Convert comma-separated string to list
        'imageUrls': updatedImageUrls,
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error updating model: $e');
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
          child: SingleChildScrollView(
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
                  controller: _colorController,
                  decoration: const InputDecoration(
                      labelText: 'Colors (comma-separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter colors';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _storageController,
                  decoration: const InputDecoration(
                      labelText: 'Storage Options (comma-separated)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter storage options';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text('Existing Images'),
                ...List.generate(_existingImageUrls.length, (index) {
                  return Column(
                    children: [
                      _pickedImages[index] != null
                          ? Image.file(_pickedImages[index]!,
                              height: 100, width: 100)
                          : Image.network(_existingImageUrls[index],
                              height: 100, width: 100),
                      ElevatedButton(
                        onPressed: () => pickImage(index),
                        child: const Text('Replace Image'),
                      ),
                    ],
                  );
                }),
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
      ),
    );
  }
}
