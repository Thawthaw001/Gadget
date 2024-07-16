import 'package:flutter/material.dart';
import 'package:thaw/Widget/brand_data.dart';
import 'package:thaw/utils/home_style.dart';

class Branddatagridview extends StatelessWidget {
  const Branddatagridview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
      ),
      itemCount: branded.length,
      itemBuilder: (context, index) {
        Map<String, String> data = branded[index];
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDFE5),
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
              Image.asset(
                data['imagePath']!,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                data['name']!,
                style: homeStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}