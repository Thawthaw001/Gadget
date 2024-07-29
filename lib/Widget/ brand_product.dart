import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thaw/Pages/full_specs.dart';

class RetrieveBrandProducts extends StatelessWidget {
  final String categoryId;
  final String brandId;

  const RetrieveBrandProducts({
    required this.categoryId,
    required this.brandId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryId.isEmpty || brandId.isEmpty) {
      return const Center(child: Text('Invalid category or brand'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories/$categoryId/brands/$brandId/models')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          return SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var product =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String imageUrl =
                    product['imageUrl'] ?? 'assets/images/default.png';
                String name = product['name'] ?? 'No name available';
                String price =
                    product['price']?.toString() ?? 'Price not available';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullSpecsPage(
                          categoryId: categoryId,
                          brandId: brandId,
                          modelId: snapshot.data!.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 200,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 100,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: "English",
                            fontSize: 10,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            fontFamily: "English",
                          ),
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
