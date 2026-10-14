import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_state.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_menu_tile.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_profile_card.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Entry point: Select Menu for Settings feature.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              SettingsDependencies.createAccountBloc()
                ..add(const LoadAccountEvent()),
        ),
        BlocProvider(
          create: (_) =>
              SettingsDependencies.createNotificationBloc()
                ..add(const LoadNotificationSettingsEvent()),
        ),
      ],
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _navigateToAccount(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    context.push(AppRoutes.settingsAccount, extra: accountBloc);
  }

  void _navigateToTheme(BuildContext context) {
    context.push(AppRoutes.settingsTheme);
  }

  void _navigateToLanguage(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    context.push(AppRoutes.settingsLanguage, extra: accountBloc);
  }

  void _navigateToDataStorage(BuildContext context) {
    context.push(AppRoutes.settingsDataStorage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final WidgetVars(:l, :c) = WidgetVars.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.settings_title,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Profile Overview Card
              SettingsProfileCard(
                onManageProfile: () => _navigateToAccount(context),
              ),

              const SizedBox(height: 16),

              // Menu: Tema
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  final isCurrentlyDark =
                      themeState.themeMode == ThemeMode.dark;
                  final themeLabel = isCurrentlyDark
                      ? l.settings_theme_badgeDark
                      : l.settings_theme_badgeLight;
                  final subtitleText = isCurrentlyDark
                      ? l.settings_theme_subtitleDark
                      : l.settings_theme_subtitleLight;

                  return SettingsMenuTile(
                    icon: Symbols.palette,
                    iconColor: const Color(0xFF6B5894),
                    iconBackgroundColor: const Color(0xFFDCD2F0),
                    title: l.theme_title,
                    subtitle: subtitleText,
                    onTap: () => _navigateToTheme(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            themeLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Symbols.chevron_right,
                          size: 20,
                          color: Color(0xFF9EAAB0),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Menu: Bahasa (Language)
              BlocBuilder<LocaleCubit, LanguageState>(
                builder: (context, localeState) {
                  final currentCode = localeState.locale.languageCode;
                  final languageLabel = l.languageName(currentCode);

                  return SettingsMenuTile(
                    icon: Symbols.translate,
                    iconColor: const Color(0xFF388E3C),
                    iconBackgroundColor: const Color(0xFFC8E6C9),
                    title: l.settings_language_title,
                    subtitle: languageLabel,
                    onTap: () => _navigateToLanguage(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: c.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            languageLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Symbols.chevron_right,
                          size: 20,
                          color: Color(0xFF9EAAB0),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Menu: Notifikasi
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, notifState) {
                  return SettingsMenuTile(
                    icon: Symbols.notifications,
                    iconColor: const Color(0xFF9E653A),
                    iconBackgroundColor: const Color(0xFFFFECCF),
                    title: l.settings_notif_title,
                    subtitle: l.settings_notif_subtitle,
                    onTap: null,
                    trailing: Switch.adaptive(
                      value: notifState.isEnabled,
                      activeTrackColor: const Color(0xFF5B93AE),
                      onChanged: (val) {
                        context.read<NotificationBloc>().add(
                          ToggleNotificationEvent(val),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Menu: Data & Penyimpanan
              SettingsMenuTile(
                icon: Symbols.database,
                iconColor: const Color(0xFF3B7A8C),
                iconBackgroundColor: const Color(0xFFCEE8F2),
                title: l.settings_data_title,
                subtitle: l.settings_data_subtitle,
                onTap: () => _navigateToDataStorage(context),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
