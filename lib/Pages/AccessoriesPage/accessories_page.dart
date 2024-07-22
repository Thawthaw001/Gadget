import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/productcard.dart';
 import 'package:thaw/utils/decoration.dart';

class Accessories extends StatefulWidget {
  final String category;

  const Accessories({super.key, required this.category});

  @override
  State<Accessories> createState() => _TabletState();
}

class _TabletState extends State<Accessories> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchModelsByCategory() async {
    List<Map<String, dynamic>> models = [];
    try {
      QuerySnapshot categoriesSnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: widget.category)
          .get();

      if (categoriesSnapshot.docs.isNotEmpty) {
        String categoryId = categoriesSnapshot.docs.first.id;

        QuerySnapshot brandsSnapshot =
            await _firestore.collection('categories/$categoryId/brands').get();

        for (var brandDoc in brandsSnapshot.docs) {
          String brandId = brandDoc.id;

          QuerySnapshot modelsSnapshot = await _firestore
              .collection('categories/$categoryId/brands/$brandId/models')
              .get();

          for (var modelDoc in modelsSnapshot.docs) {
            Map<String, dynamic> modelData =
                modelDoc.data() as Map<String, dynamic>;
            models.add(modelData);
          }
        }
      }
    } catch (e) {
      // Handle errors here
    }

    return models;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Models'),
      ),
      body: Container(
        decoration: getDecoration(),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchModelsByCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No models found'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var model = snapshot.data![index];
                          return ProductCard(model: model, categoryId: '', brandId: '',);
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
