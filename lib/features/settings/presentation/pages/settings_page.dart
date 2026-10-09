import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_state.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_metric_card.dart';
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
          create: (_) => SettingsDependencies.createAccountBloc()
            ..add(const LoadAccountEvent()),
        ),
        BlocProvider(
          create: (_) => SettingsDependencies.createNotificationBloc()
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
    context.push(AppRoutes.settingsAccount);
  }

  void _navigateToTheme(BuildContext context) {
    context.push(AppRoutes.settingsTheme);
  }

  void _navigateToNotifications(BuildContext context) {
    context.push(AppRoutes.settingsNotifications);
  }

  void _navigateToDataStorage(BuildContext context) {
    context.push(AppRoutes.settingsDataStorage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF13171F) : const Color(0xFFF9FAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan',
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

              // Two Metric Cards (Kosakata & Cadangan)
              Row(
                children: [
                  Expanded(
                    child: SettingsMetricCard(
                      backgroundColor: isDark ? const Color(0xFF2A221C) : const Color(0xFFFFF7ED),
                      borderColor: isDark ? const Color(0xFF453526) : const Color(0xFFFFEDD5),
                      iconWidget: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE6D2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Symbols.translate,
                          color: Color(0xFF9E653A),
                          size: 15,
                        ),
                      ),
                      title: 'Kosakata',
                      contentWidget: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '142 ',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'Kata',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF7A868C),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SettingsMetricCard(
                      backgroundColor: isDark ? const Color(0xFF1B2820) : const Color(0xFFF0F9F3),
                      borderColor: isDark ? const Color(0xFF274332) : const Color(0xFFDCF0E2),
                      iconWidget: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6EEDF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Symbols.cloud,
                          color: Color(0xFF2D774B),
                          size: 15,
                        ),
                      ),
                      title: 'Cadangan',
                      contentWidget: const Row(
                        children: [
                          Icon(
                            Symbols.check_circle,
                            color: Color(0xFF2D774B),
                            size: 18,
                            weight: 700,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Aman & Terkini',
                              style: TextStyle(
                                color: Color(0xFF2D774B),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Menu: Akun
              SettingsMenuTile(
                icon: Symbols.person_edit,
                iconColor: const Color(0xFFB5703E),
                iconBackgroundColor: const Color(0xFFFFE7D1),
                title: 'Akun',
                subtitle: 'Ubah nama pengguna & foto',
                onTap: () => _navigateToAccount(context),
              ),
              const SizedBox(height: 12),

              // Menu: Tema
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  final isCurrentlyDark = themeState.themeMode == ThemeMode.dark;
                  final themeLabel = isCurrentlyDark ? 'Gelap' : 'Terang';
                  final subtitleText = isCurrentlyDark
                      ? 'Mode gelap (hemat baterai)'
                      : 'Mode terang (nyaman di mata)';

                  return SettingsMenuTile(
                    icon: Symbols.palette,
                    iconColor: const Color(0xFF6B5894),
                    iconBackgroundColor: const Color(0xFFDCD2F0),
                    title: 'Tema',
                    subtitle: subtitleText,
                    onTap: () => _navigateToTheme(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C3847) : const Color(0xFFEFF2F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            themeLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4A555B),
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
                    title: 'Notifikasi',
                    subtitle: 'Pengingat belajar harian',
                    onTap: () => _navigateToNotifications(context),
                    trailing: Switch.adaptive(
                      value: notifState.isEnabled,
                      activeTrackColor: const Color(0xFF5B93AE),
                      onChanged: (val) {
                        context.read<NotificationBloc>().add(ToggleNotificationEvent(val));
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
                title: 'Data & Penyimpanan',
                subtitle: 'Impor, ekspor, & cadangan profil',
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
