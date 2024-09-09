import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thaw/Pages/full_specs.dart';

class ProductSearchDelegate extends SearchDelegate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore
          .collectionGroup('models')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var model = doc.data() as Map<String, dynamic>;
              var categoryId = doc.reference.parent.parent!.parent.parent!.id;
              var brandId = doc.reference.parent.parent!.id;

              List<String> imageUrls =
                  List<String>.from(model['imageUrls'] ?? []);

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  leading: imageUrls.isNotEmpty
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: const Icon(Icons.image_not_supported),
                        ),
                  title: Text(model['name'] ?? 'Unknown Model'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${model['price'] ?? '0'} Ks'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullSpecsPage(
                          categoryId: categoryId,
                          brandId: brandId,
                          modelId: doc.id, categoryName: 'Accessories',
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search for products'),
    );
  }
}
