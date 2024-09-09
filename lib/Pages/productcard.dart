// import 'dart:math';  // Import this for random selection

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thaw/Pages/full_specs.dart';

class ProductCard extends StatelessWidget {
  final String categoryId;
  final String brandId;
  final Map<String, dynamic> model;

  const ProductCard({
    super.key,
    required this.categoryId,
    required this.brandId,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    // Select a random image from the list of imageUrls
    String? selectedImageUrl;
    if (model['imageUrls'] != null && model['imageUrls'].isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(model['imageUrls'].length);
      selectedImageUrl = model['imageUrls'][randomIndex];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: selectedImageUrl != null && selectedImageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Image.network(
                            selectedImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: constraints.maxHeight * 0.5,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported,
                                  size: 100),
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0)),
                        child: Container(
                          color: Colors.grey,
                          child:
                              const Icon(Icons.image_not_supported, size: 100),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model['name'] ?? 'Unknown Model',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullSpecsPage(
                                categoryId: categoryId,
                                brandId: brandId,
                                modelId: model['id'], categoryName: 'Aceesories',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/specs.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            const SizedBox(width:2.0),
                            const Text(
                              'Full Specs',
                              style: TextStyle(
                                  fontSize:12.0,
                                  fontFamily: "English",
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
