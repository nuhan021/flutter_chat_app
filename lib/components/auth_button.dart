import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color? color;
  const AuthButton({super.key, this.onTap, required this.text, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
