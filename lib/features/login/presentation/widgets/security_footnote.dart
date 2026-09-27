import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SecurityFootnote extends StatelessWidget {
  const SecurityFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Icon(
            Icons.lock_open_outlined,
            size: 18,
          ),
          Text(
            l.securityFootnote,
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