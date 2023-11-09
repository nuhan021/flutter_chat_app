import 'package:flutter/material.dart';

class AuthLoginIconButton extends StatelessWidget {
  final void Function() onTap;
  final String icon;
  const AuthLoginIconButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(9),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(icon, fit: BoxFit.fill,),
      ),
    );
  }
}

class AuthSignUpIconButton extends StatelessWidget {
  final String title;
  final String icon;
  final void Function() onTap;
  const AuthSignUpIconButton({super.key, required this.icon, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(9),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon),
            const SizedBox(width: 15,),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}

