import 'package:flutter/material.dart';

class SecurityFootnote extends StatelessWidget {
  const SecurityFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Icon(
            Icons.lock_open_outlined,
            size: 18,
          ),
          Text(
            "Profil Anda tersimpan aman di perangkat ini tanpa kata sandi",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}