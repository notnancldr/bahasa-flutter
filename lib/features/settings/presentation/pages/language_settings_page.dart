import 'package:bahasa/core/constants/language_options.dart';
import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/language_picker.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class LanguageSettingsPage extends StatelessWidget {
  final AccountBloc? bloc;

  const LanguageSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc!,
        child: const LanguageSettingsView(),
      );
    }

    try {
      context.read<AccountBloc>();
      return const LanguageSettingsView();
    } catch (_) {
      return BlocProvider(
        create: (_) =>
            SettingsDependencies.createAccountBloc()
              ..add(const LoadAccountEvent()),
        child: const LanguageSettingsView(),
      );
    }
  }
}

class LanguageSettingsView extends StatelessWidget {
  const LanguageSettingsView({super.key});

  void _onLanguageSelected(
    BuildContext context,
    String newLanguageCode,
    String currentLanguageCode,
  ) {
    if (newLanguageCode == currentLanguageCode) return;

    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Symbols.info,
                color: c.primary,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l.settings_language_alert_title,
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l.settings_language_alert_message,
            style: t.bodyMedium?.copyWith(
              color: c.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l.settings_language_alert_cancel,
                style: t.labelLarge?.copyWith(
                  color: c.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // 1. Update persisted account profile
                context.read<AccountBloc>().add(
                      ChangeDefaultLanguageEvent(newLanguageCode),
                    );
                // 2. Change active app locale immediately
                context.read<LocaleCubit>().changeLanguage(newLanguageCode);
              },
              style: FilledButton.styleFrom(
                backgroundColor: c.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l.settings_language_alert_confirm,
                style: t.labelLarge?.copyWith(
                  color: c.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final currentLanguageCode = switch (accountState) {
          AccountLoaded(:final profile) => profile.defaultLanguage,
          AccountLanguageUpdated(:final profile) => profile.defaultLanguage,
          AccountUsernameUpdated(:final profile) => profile.defaultLanguage,
          AccountPhotoUpdated(:final profile) => profile.defaultLanguage,
          _ => context.watch<LocaleCubit>().state.locale.languageCode,
        };

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(title: l.settings_title),
                  const SizedBox(height: 24),
                  Text(
                    l.settings_language_title,
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: c.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.settings_language_subtitle,
                    style: t.bodyMedium?.copyWith(
                      color: c.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LanguagePicker(
                      options: kAppUiLanguageOptions,
                      selectedLanguage: currentLanguageCode,
                      onLanguageSelected: (code) => _onLanguageSelected(
                        context,
                        code,
                        currentLanguageCode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
