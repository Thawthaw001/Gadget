import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewCategoriesScreen extends StatelessWidget {
  const ViewCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Categories'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          }

          if (snapshot.hasData) {
            final categories = snapshot.data!.docs;

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return SizedBox(
                  height:90,
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.pinkAccent[50],
                    child: Center(
                      child: ListTile(
                        leading: Image.network(
                          category['imageUrl'],
                          width: 100,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          category['name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "English",
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () async {
                            // Delete the category from Firestore
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(category.id)
                                .delete();
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No categories found'));
        },
      ),
    );
  }
}
