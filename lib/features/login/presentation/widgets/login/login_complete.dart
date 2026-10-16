import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginComplete extends StatelessWidget {
  const LoginComplete({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final t = theme.textTheme;
    final c = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
                border: BoxBorder.all(width: 1, color: c.primaryContainer),
                boxShadow: [
                  BoxShadow(blurRadius: 16, color: c.primary.withAlpha(60)),
                ],
              ),
              child: Icon(
                Symbols.check,
                size: 48,
                weight: 800,
                color: c.onPrimaryContainer,
              ),
            ),
          ),
        ),
        Text(
          l.newProfile_complete_title,
          style: t.titleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          l.newProfile_complete_description,
          style: t.labelLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
