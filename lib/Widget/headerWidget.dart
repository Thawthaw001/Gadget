import 'package:flutter/material.dart';
import 'package:thaw/utils/formfield.dart';

// ignore: camel_case_types
class headerWidget extends StatelessWidget {
  final String brandLogoUrl;
  final String title;

  const headerWidget(
      {super.key, required this.brandLogoUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
         CircleAvatar(radius: (30),
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius:BorderRadius.circular(50),
              child: Image.asset("assets/images/SamsungBrand.png"),
            )
        ),
          const SizedBox(width: 10),
          Text(
            title,
            style: formfieldStyle,
          )
        ],
      ),
    );
  }
}
