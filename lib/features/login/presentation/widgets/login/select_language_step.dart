import 'package:bahasa/core/widgets/language_picker.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageStep extends StatelessWidget {
  final InputState state;

  const SelectLanguageStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginStepHeader(
          l.newProfile_step_language_title,
          description: l.newProfile_step_language_description,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: LanguagePicker(
            selectedLanguage: state.language,
            onLanguageSelected: (code) {
              context.read<LoginBloc>().add(
                SelectDefaultLanguage(language: code),
              );
            },
          ),
        ),
      ],
    );
  }
}
