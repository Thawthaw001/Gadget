import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'related_models_page.dart'; // Import the new page

class BrandDataGridView extends StatelessWidget {
  final String categoryId;

  const BrandDataGridView({required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No brands found'));
        } else {
          return SizedBox(
            height: 50,  
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var brand =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String brandId = snapshot.data!.docs[index].id;
                String name = brand['name'] ?? 'No name available';
                String imageUrl = brand['imageUrl'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RelatedModelsPage(
                          categoryId: categoryId,
                          brandId: brandId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 150, // Set a fixed width for each item
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          blurStyle: BlurStyle.inner,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                height: 45,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 80),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 18,
                            fontFamily: "English",
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
