import 'package:flutter/material.dart';
import 'package:thaw/utils/decoration.dart';

class Indicator extends StatelessWidget {
  final String _passwordStrength = '';

  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _passwordStrength == 'Weak'
          ? 0.3
          : _passwordStrength == 'Medium'
              ? 0.6
              : _passwordStrength == 'Strong'
                  ? 1.0
                  : 0.0,
      color: getStrengthColor(_passwordStrength),
      backgroundColor: Colors.grey[300],
    );
  }
}
