import 'package:flutter/material.dart';
import 'package:thaw/utils/formfield.dart';

class GadgeTextFormField extends StatelessWidget {
  const GadgeTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.validator,
    this.focusNode,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: formfieldStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
