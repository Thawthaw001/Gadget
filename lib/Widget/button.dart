import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 60,
      child: ElevatedButton(
          onPressed:onPressed,
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 10),
          )),
    );
  }
}
