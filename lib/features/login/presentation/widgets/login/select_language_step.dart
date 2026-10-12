import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class _LanguageOption {
  final String code;
  final String name;

  const _LanguageOption({required this.code, required this.name});
}

const List<_LanguageOption> _kLanguages = [
  _LanguageOption(code: 'id', name: 'Bahasa Indonesia'),
  _LanguageOption(code: 'en', name: 'English'),
  _LanguageOption(code: 'es', name: 'Español'),
  _LanguageOption(code: 'ja', name: '日本語'),
  _LanguageOption(code: 'ko', name: '한국어'),
  _LanguageOption(code: 'fr', name: 'Francais'),
];

class SelectLanguageStep extends StatefulWidget {
  final InputState state;

  const SelectLanguageStep({super.key, required this.state});

  @override
  State<SelectLanguageStep> createState() => _SelectLanguageStepState();
}

class _SelectLanguageStepState extends State<SelectLanguageStep> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final filtered = _query.isEmpty
        ? _kLanguages
        : _kLanguages.where((lang) {
            final q = _query.toLowerCase();
            return lang.name.toLowerCase().contains(q);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginStepHeader(
          l.newProfile_step_language_title,
          description: l.newProfile_step_language_description,
        ),

        SizedBox(height: 32),

        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: l.newProfile_step_language_search,
            prefixIcon: Icon(Symbols.search, size: 18),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        SizedBox(height: 16),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: filtered.length,
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lang = filtered[index];
              final isSelected = lang.code == widget.state.language;

              return _LanguageTile(
                option: lang,
                selected: isSelected,
                onTap: () {
                  context.read<LoginBloc>().add(
                    SelectDefaultLanguage(language: lang.code),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final c = theme.colorScheme;
    final l = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? c.primaryContainer.withValues(alpha: 0.25)
              : c.surface,
          border: Border.all(
            color: selected ? c.primaryContainer : c.outline,
            width: selected ? 2 : 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: BoxBorder.all(color: c.secondary),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: c.surfaceContainerHighest,
                child: CountryFlag.fromLanguageCode(
                  option.code,
                  theme: const ImageTheme(shape: Circle()),
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l.languageName(option.code),
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: c.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            _SelectionIndicator(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool selected;

  const _SelectionIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        border: Border.all(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      child: selected
          ? Icon(Icons.check, size: 16, color: colorScheme.onPrimaryContainer)
          : null,
    );
  }
}
