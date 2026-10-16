import 'package:bahasa/core/constants/language_options.dart';
import 'package:bahasa/core/widgets/custom_options.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class LanguagePicker extends StatefulWidget {
  final String? selectedLanguage;
  final ValueChanged<String> onLanguageSelected;
  final List<LanguageOption> options;
  final String? searchHint;
  final bool shrinkWrap;

  const LanguagePicker({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    this.options = kLanguageOptions,
    this.searchHint,
    this.shrinkWrap = false,
  });

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final l = AppLocalizations.of(context)!;

    final filtered = _query.isEmpty
        ? widget.options
        : widget.options.where((lang) {
            final q = _query.toLowerCase();
            final matchesNative = lang.name.toLowerCase().contains(q);
            final matchesLocalized = l
                .languageName(lang.code)
                .toLowerCase()
                .contains(q);
            return matchesNative || matchesLocalized;
          }).toList();

    final listView = ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lang = filtered[index];
        final isSelected = lang.code == widget.selectedLanguage;

        return CustomOption(
          selected: isSelected,
          onTap: () => widget.onLanguageSelected(lang.code),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: c.secondary),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: c.surfaceContainerHighest,
              child: CountryFlag.fromLanguageCode(
                lang.code,
                theme: const ImageTheme(shape: Circle()),
              ),
            ),
          ),
          title: Text(
            lang.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            l.languageName(lang.code),
            style: theme.textTheme.labelMedium?.copyWith(
              color: c.onSurfaceVariant,
            ),
          ),
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: widget.searchHint ?? l.newProfile_step_language_search,
            prefixIcon: const Icon(Symbols.search, size: 18),
            filled: true,
            fillColor: c.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (widget.shrinkWrap) listView else Expanded(child: listView),
      ],
    );
  }
}
