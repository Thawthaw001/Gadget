import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thaw/Pages/basket.dart';
import 'package:thaw/Pages/bottom_bar.dart';
import 'package:thaw/Widget/model_provider.dart';

class FullSpecsPage extends StatelessWidget {
  final String categoryId;
  final String brandId;
  final String modelId;
  final String categoryName; // Add this parameter

  const FullSpecsPage({
    super.key,
    required this.categoryId,
    required this.brandId,
    required this.modelId,
    required this.categoryName, // Initialize this parameter
  });

  Future<Map<String, dynamic>> _fetchModelDetails() async {
    try {
      DocumentSnapshot modelSnapshot = await FirebaseFirestore.instance
          .collection('categories/$categoryId/brands/$brandId/models')
          .doc(modelId)
          .get();

      if (modelSnapshot.exists) {
        return modelSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Model not found");
      }
    } catch (e) {
      throw Exception("Error fetching model details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Full Specs'),
        actions: [
          Consumer<ModelProvider>(
            builder: (context, modelProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BasketPage(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${modelProvider.basket.length}',
                        style:
                            const TextStyle(color: Colors.purple, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchModelDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              var model = snapshot.data!;
              var imageUrls = (model['imageUrls'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  [];
              var colors = (model['colors'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  [];
              var storageOptions = (model['storageOptions'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  [];

              return Consumer<ModelProvider>(
                builder: (context, modelProvider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Slideshow Section
                        if (imageUrls.isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                              ),
                              items: imageUrls.map((url) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey,
                                            child: const Icon(
                                                Icons.image_not_supported,
                                                size: 100),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 16.0),

                        // Brand's Model Name & Price
                        Container(
                          width: double.infinity,
                          height: 100,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model['name'] ?? 'Unknown Model',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${model['price'] ?? 'Kyats'} Ks',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Stock Status
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Stock Status:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "English",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                model['inStock'] ?? false
                                    ? 'In Stock'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "English",
                                  fontWeight: FontWeight.bold,
                                  color: model['inStock'] ?? false
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Color and Storage Options
                        Container(
                          width: double.infinity,
                          height: 300,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Color Options:',
                                style: TextStyle(
                                    fontFamily: "English",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: colors.map((color) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      modelProvider.setSelectedColor(color);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Text(
                                      color,
                                      style: TextStyle(
                                        color:
                                            modelProvider.selectedColor == color
                                                ? Colors.green
                                                : Colors.pink,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20.0),
                              const Text(
                                'Storage Options:',
                                style: TextStyle(
                                    fontFamily: "English",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 10.0),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: storageOptions.map((storage) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      modelProvider.setSelectedStorage(storage);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.red, width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Text(
                                      storage,
                                      style: TextStyle(
                                        color: modelProvider.selectedStorage ==
                                                storage
                                            ? Colors.orange
                                            : Colors.pink,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Specifications Section
                        Container(
                          width: double.infinity,
                          height: 450,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Specifications: ${model['specs']}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: "English",
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('categories/$categoryId/brands/$brandId/models')
            .doc(modelId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('Model not found'));
          } else {
            final model = snapshot.data!.data() as Map<String, dynamic>;
            final int availableQuantity = model['quantity'] ?? 0;

            return BottomNavBar(
              onAddToCartPressed: () {
                final modelProvider =
                    Provider.of<ModelProvider>(context, listen: false);
                if (modelProvider.quantity > 0 &&
                    modelProvider.selectedColor.isNotEmpty &&
                    modelProvider.selectedStorage.isNotEmpty) {
                  if (modelProvider.quantity > availableQuantity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'This model has only $availableQuantity items available.'),
                      ),
                    );
                    return;
                  }

                  modelProvider.addToCart(
                    modelId,
                    model['imageUrl'] ?? '',
                    model['name'] ?? '',
                    model['price']?.toDouble() ?? 0.0,
                    modelProvider.selectedColor,
                    modelProvider.selectedStorage,
                    modelProvider.quantity,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart'),
                    ),
                  );
                } else if (modelProvider.selectedColor.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Color must be chosen.'),
                    ),
                  );
                } else if (modelProvider.selectedStorage.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Storage must be chosen.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quantity must be greater than zero.'),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
 