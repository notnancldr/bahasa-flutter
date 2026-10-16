import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class StartHostStep extends StatelessWidget {
  const StartHostStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .stretch,
      children: [
        Row(
          mainAxisAlignment: .center,
          children: [CircularProgressIndicator()],
        ),
        SizedBox(height: 12),
        Text(l.process_preparing, textAlign: TextAlign.center),
      ],
    );
  }
}
