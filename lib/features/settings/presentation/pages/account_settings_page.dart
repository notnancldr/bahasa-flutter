import 'dart:ui';

import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_alert_dialog.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_menu_tile.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AccountSettingsPage extends StatelessWidget {
  final AccountBloc? bloc;

  const AccountSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          (bloc ?? SettingsDependencies.createAccountBloc())
            ..add(const LoadAccountEvent()),
      child: const AccountSettingsView(),
    );
  }
}

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  Future<void> _showDeleteConfirmDialog(BuildContext context) async {
    final WidgetVars(:c, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      builder: (dialogCtx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: SettingsAlertDialog(
          icon: Symbols.priority_high,
          iconColor: const Color(0xFFC62828),
          iconBackgroundColor: isDark
              ? const Color(0xFF381E1E)
              : const Color(0xFFFDE8E8),
          title: l.account_delete_dialogTitle,
          message: l.account_delete_dialogBody,
          actions: [
            EmbossedButton(
              l.cancel,
              type: EmbossedButtonType.outlined,
              color: EmbossedButtonColor(
                border: c.primary,
                foreground: c.primary,
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(false),
            ),
            EmbossedButton(
              l.account_delete_confirmButton,
              type: EmbossedButtonType.filled,
              color: const EmbossedButtonColor(
                background: Color(0xFFD26B6B),
                foreground: Colors.white,
                shadow: Color(0xFFB34242),
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
            ),
          ],
        ),
      ),
    );

    if (context.mounted) {
      if (confirmed == true) {
        context.read<AccountBloc>().add(const ConfirmDeleteProfileEvent());
      } else {
        context.read<AccountBloc>().add(const CancelAccountActionEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile and data deleted successfully.'),
            ),
          );
          context.go(AppRoutes.login);
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AccountConfirmDeletePrompt) {
          _showDeleteConfirmDialog(context);
        }
      },
      builder: (context, state) {
        if (state is AccountLoading || state is AccountDeleting) {
          return Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF13171F)
                : const Color(0xFFF9FAFA),
            body: const SafeArea(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        String username = 'Rizky_23';
        if (state is AccountLoaded) {
          username = state.profile.username.isNotEmpty
              ? state.profile.username
              : username;
        }

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  PageHeader(title: l.settings_title),
                  const SizedBox(height: 24),

                  // Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E2630)
                          : const Color(0xFFF3F3F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFD5B5),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                username.isNotEmpty
                                    ? username[0].toUpperCase()
                                    : 'R',
                                style: const TextStyle(
                                  color: Color(0xFF8A5328),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Color(0xFFA8D5E2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Symbols.school,
                                size: 16,
                                color: Color(0xFF2C6378),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          username,
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.account_joinedSince,
                          style: t.bodySmall?.copyWith(
                            color: c.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Edit Profil Option
                  SettingsMenuTile(
                    icon: Symbols.edit,
                    iconColor: const Color(0xFFB5703E),
                    iconBackgroundColor: const Color(0xFFFFE7D1),
                    title: l.account_editProfile,
                    subtitle: l.account_editProfile_subtitle,
                    onTap: () {
                      final bloc = context.read<AccountBloc>();
                      context.push(AppRoutes.settingsAccountEdit, extra: bloc);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Hapus Profil Option
                  SettingsMenuTile(
                    icon: Symbols.delete,
                    iconColor: const Color(0xFFD26B6B),
                    iconBackgroundColor: isDark
                        ? const Color(0xFF381E1E)
                        : const Color(0xFFFDE8E8),
                    title: l.account_deleteProfile,
                    subtitle: l.account_deleteProfile_subtitle,
                    onTap: () => _showDeleteConfirmDialog(context),
                  ),

                  const SizedBox(height: 40),

                  // Footer tagline
                  Text(
                    l.account_footer,
                    textAlign: TextAlign.center,
                    style: t.bodySmall?.copyWith(
                      color: c.onSurfaceVariant.withAlpha(160),
                      fontSize: 12,
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
