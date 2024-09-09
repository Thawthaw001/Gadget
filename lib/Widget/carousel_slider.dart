import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
    required this.docs,
    required List<String> assetImages,
  });

  final List<DocumentSnapshot<Object?>> docs;

  bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 2.5,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 2.0,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
        scrollDirection: Axis.horizontal,
      ),
      items: docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'];
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: isValidUrl(imageUrl)
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.75,
                            )
                          : const Icon(Icons.broken_image,
                              size: 50), // Placeholder for invalid URLs
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
