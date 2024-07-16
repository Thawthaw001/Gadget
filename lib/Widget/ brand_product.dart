// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:thaw/Widget/brand_product_data.dart';

class RetrieveBrandProducts extends StatelessWidget {
  const RetrieveBrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    // Static data list

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: brandProductData.length,
      itemBuilder: (context, index) {
        Map<String, String> data = brandProductData[index];

        // Use the static data
        String imageAsset = data['imageAsset'] ?? 'assets/images/default.png';
        String name = data['name'] ?? 'No name available';
        String price = data['price'] ?? 'Price not available';

        return Container(
          width: 150,
          height: 200,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDFE5),
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
              Image.asset(
                imageAsset,
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
                  fontFamily: "English",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
