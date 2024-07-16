import 'package:flutter/material.dart';

class AnimatedCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;

  const AnimatedCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height:
                  width, // Keeping height and width equal for a square aspect
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            FractionalTranslation(
              translation: const Offset(0, -0.5),
              child: Container(
                width: width * 0.6, // Responsive width
                height: width * 0.2, // Responsive height
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'All item 10 % off',
                    style: TextStyle(
                      fontSize: 16, // Responsive font size
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            FractionalTranslation(
              translation: const Offset(0, -1),
              child: Text(
                'Kyats \$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Responsive font size
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
