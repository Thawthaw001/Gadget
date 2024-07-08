import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({Key? key}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  String selectedCategoryId = '';
  List<DropdownMenuItem<String>> categoryItems = [];
  final TextEditingController brandNameController = TextEditingController();

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

  Future<void> addBrand() async {
    if (selectedCategoryId.isNotEmpty && brandNameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategoryId)
          .collection('brands')
          .add({
        'name': brandNameController.text,
      });

      brandNameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Brand added successfully!')),
      );

      Navigator.pushNamed(context, '/brandmodelpanel');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and enter a brand name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              hint: Text('Select a Category'),
              value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
              items: categoryItems,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoryId = newValue!;
                });
              },
            ),
            TextField(
              controller: brandNameController,
              decoration: InputDecoration(labelText: 'Brand Name'),
            ),
            ElevatedButton(
              onPressed: addBrand,
              child: Text('Add Brand'),
            ),
          ],
        ),
      ),
    );
  }
}
