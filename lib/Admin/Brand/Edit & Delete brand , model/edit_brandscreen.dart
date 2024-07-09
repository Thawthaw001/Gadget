import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBrandScreen extends StatefulWidget {
  final String categoryId;
  final String brandId;

  const EditBrandScreen({
    required this.categoryId,
    required this.brandId,
  });

  @override
  _EditBrandScreenState createState() => _EditBrandScreenState();
}

class _EditBrandScreenState extends State<EditBrandScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    fetchBrandDetails();
  }

  Future<void> fetchBrandDetails() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('brands')
        .doc(widget.brandId)
        .get();

    if (snapshot.exists) {
      setState(() {
        _nameController.text = snapshot['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Brand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Brand Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update brand name
                FirebaseFirestore.instance
                    .collection('categories')
                    .doc(widget.categoryId)
                    .collection('brands')
                    .doc(widget.brandId)
                    .update({'name': _nameController.text});

                Navigator.pop(context); // Return to previous screen
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
