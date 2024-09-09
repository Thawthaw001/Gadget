import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/full_specs.dart';

class RelatedModelsPage extends StatelessWidget {
  final String categoryId;
  final String brandId;

  const RelatedModelsPage({
    required this.categoryId,
    required this.brandId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Related Models'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories/$categoryId/brands/$brandId/models')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No models found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var model =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String modelId = snapshot.data!.docs[index].id;
                String modelName = model['name'] ?? 'No name available';
                List<String> imageUrls =
                    List<String>.from(model['imageUrls'] ?? []);
                double price = model['price'] ?? 0.0;
                int quantity = model['quantity'] ?? 0;

                return ListTile(
                  title: Text(modelName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: $price Ks'),
                      Text('Quantity: $quantity'),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, imageIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                imageUrls[imageIndex],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullSpecsPage(
                          categoryId: categoryId,
                          brandId: brandId,
                          modelId: modelId, categoryName: 'Accessories',
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
