import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/productcard.dart';
import 'package:thaw/utils/decoration.dart';

class GamingPCPage extends StatefulWidget {
  final String category;

  const GamingPCPage({super.key, required this.category});

  @override
  State<GamingPCPage> createState() => GamingPCPageState();
}

class GamingPCPageState extends State<GamingPCPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedBrandId = '';
  List<DropdownMenuItem<String>> brandItems = [];
  List<Map<String, dynamic>> models = [];

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      QuerySnapshot categoriesSnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: widget.category)
          .get();

      if (categoriesSnapshot.docs.isNotEmpty) {
        String categoryId = categoriesSnapshot.docs.first.id;

        QuerySnapshot brandsSnapshot =
            await _firestore.collection('categories/$categoryId/brands').get();

        setState(() {
          brandItems = brandsSnapshot.docs
              .map((doc) => DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(doc['name']),
                  ))
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  Future<void> fetchModelsByBrand(String brandId) async {
    List<Map<String, dynamic>> fetchedModels = [];
    try {
      QuerySnapshot categoriesSnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: widget.category)
          .get();

      if (categoriesSnapshot.docs.isNotEmpty) {
        String categoryId = categoriesSnapshot.docs.first.id;

        QuerySnapshot modelsSnapshot = await _firestore
            .collection('categories/$categoryId/brands/$brandId/models')
            .get();

        for (var modelDoc in modelsSnapshot.docs) {
          Map<String, dynamic> modelData =
              modelDoc.data() as Map<String, dynamic>;

          modelData['categoryId'] = categoryId;
          modelData['brandId'] = brandId;
          modelData['id'] = modelDoc.id;
          modelData['name'] = modelData['name'] ?? 'Unknown Model';
          modelData['price'] = modelData['price'] ?? 0.0;
          modelData['specs'] =
              modelData['specs'] ?? 'No specifications available';
          modelData['imageUrl'] = modelData['imageUrl'] ?? '';
          modelData['colors'] = modelData['colors'] ?? [];
          modelData['storageOptions'] = modelData['storageOptions'] ?? [];
          modelData['inStock'] = modelData['inStock'] ?? false;
          modelData['quantity'] = modelData['quantity'] ?? 0;

          fetchedModels.add(modelData);
        }

        setState(() {
          models = fetchedModels;
        });
      }
    } catch (e) {
      print('Error fetching models by brand: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GamingPC Models'),
      ),
      body: Container(
        decoration: getDecoration(),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Select a Brand'),
                  value: selectedBrandId.isEmpty ? null : selectedBrandId,
                  items: brandItems,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBrandId = newValue!;
                      fetchModelsByBrand(selectedBrandId);
                    });
                  },
                ),
              ),
              if (models.isEmpty) const Center(child: Text('No models found')),
              if (models.isNotEmpty)
                Padding(
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
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      var model = models[index];
                      return ProductCard(
                        model: model,
                        categoryId: model['categoryId'],
                        brandId: model['brandId'],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
