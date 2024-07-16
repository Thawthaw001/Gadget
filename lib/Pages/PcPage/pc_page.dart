import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/PcPage/pc_productcard.dart';
import 'package:thaw/utils/decoration.dart';

class Pc extends StatefulWidget {
  const Pc({super.key});

  @override
  State<Pc> createState() => _PcState();
}

class _PcState extends State<Pc> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchAllModels() async {
    List<Map<String, dynamic>> models = [];
    const String category = 'Pc';

    try {
      QuerySnapshot categoriesSnapshot =
          await _firestore.collection('categories').get();

      for (var categoryDoc in categoriesSnapshot.docs) {
        String categoryId = categoryDoc.id;

        QuerySnapshot brandsSnapshot =
            await _firestore.collection('categories/$categoryId/brands').get();

        for (var brandDoc in brandsSnapshot.docs) {
          String brandId = brandDoc.id;

          QuerySnapshot modelsSnapshot = await _firestore
              .collection('categories/$categoryId/brands/$brandId/models')
              .where('category', isEqualTo: category)
              .get();

          for (var modelDoc in modelsSnapshot.docs) {
            Map<String, dynamic> modelData =
                modelDoc.data() as Map<String, dynamic>;
            models.add(modelData);
          }
        }
      }
    } catch (e) {
      // print('Error fetching models: $e');
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
                future: _fetchAllModels(),
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
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        shrinkWrap:
                            true, // Make GridView take minimum height required
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
                          return ProductCard(model: model);
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
