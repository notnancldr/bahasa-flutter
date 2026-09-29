import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login/login_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class _LanguageOption {
  final String code;
  final String name;
  final String subtitle;
  final String flagEmoji;

  const _LanguageOption({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.flagEmoji,
  });
}

const List<_LanguageOption> _kLanguages = [
  _LanguageOption(code: 'id', name: 'Bahasa Indonesia', subtitle: 'Indonesia (Default)', flagEmoji: '🇮🇩'),
  _LanguageOption(code: 'en', name: 'English', subtitle: 'Inggris', flagEmoji: '🇬🇧'),
  _LanguageOption(code: 'es', name: 'Español', subtitle: 'Spanyol', flagEmoji: '🇪🇸'),
  _LanguageOption(code: 'ja', name: '日本語', subtitle: 'Jepang', flagEmoji: '🇯🇵'),
  _LanguageOption(code: 'ko', name: '한국어', subtitle: 'Korea', flagEmoji: '🇰🇷'),
  _LanguageOption(code: 'fr', name: 'Francais', subtitle: 'Prancis', flagEmoji: '🇫🇷'),
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
    final filtered = _query.isEmpty
        ? _kLanguages
        : _kLanguages.where((lang) {
            final q = _query.toLowerCase();
            return lang.name.toLowerCase().contains(q) ||
                lang.subtitle.toLowerCase().contains(q);
          }).toList();

    final l = AppLocalizations.of(context)!;

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
            separatorBuilder: (_, __) => SizedBox(height: 12),
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
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? colorScheme.primaryContainer.withValues(alpha: 0.25)
              : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primaryContainer : colorScheme.outline,
            width: selected ? 2 : 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Text(option.flagEmoji, style: TextStyle(fontSize: 20)),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    option.subtitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
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
          color: selected ? colorScheme.primaryContainer : colorScheme.outlineVariant,
          width: 2,
        ),
      ),
      child: selected
          ? Icon(Icons.check, size: 16, color: colorScheme.onPrimaryContainer)
          : null,
    );
  }
}