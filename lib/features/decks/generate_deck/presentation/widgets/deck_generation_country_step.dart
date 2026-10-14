import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/language_picker.dart';
import 'package:flutter/material.dart';

/// Step 2: Target language / country selection.
class DeckGenerationCountryStep extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const DeckGenerationCountryStep({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_country_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_country_desc,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: LanguagePicker(
            selectedLanguage: selectedLanguage.isEmpty
                ? null
                : selectedLanguage,
            onLanguageSelected: onLanguageSelected,
            searchHint: l.deck_gen_country_search,
          ),
        ),
      ],
    );
  }
}
