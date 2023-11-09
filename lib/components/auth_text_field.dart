import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText;
  final void Function(String)? onChange;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChange, this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChange,
      decoration: InputDecoration(
        errorText: errorText,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(9),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(9),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(9),
        ),
        fillColor: Colors.grey[100],
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
