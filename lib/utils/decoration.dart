 import 'package:flutter/material.dart';

BoxDecoration getDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFFFFFFFF), // #FFFFFF with 100%
            const Color(0xFFFFDFE5), // #FFDFE5 with 100%
            const Color(0xFFAACCCC).withOpacity(0.93), // #AACCCC with 93%
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      );
  }
    Color getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.black;
    }
    }