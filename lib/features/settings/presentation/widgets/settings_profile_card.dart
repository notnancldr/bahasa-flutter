import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingsProfileCard extends StatelessWidget {
  final VoidCallback onManageProfile;

  const SettingsProfileCard({super.key, required this.onManageProfile});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :l, :s) = WidgetVars.of(context);

    final cardTheme = theme.cardTheme;
    final cardShape = cardTheme.shape as RoundedRectangleBorder;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final profile = state.profile;
        final username = (profile != null && profile.username.trim().isNotEmpty)
            ? profile.username
            : 'Unknown';

        return Card(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: c.primaryContainer.withAlpha(80),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.person,
                    color: s.primaryDark,
                    size: 26,
                    fill: 1.0,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.settings_activeStudent,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.secodaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onManageProfile,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: c.primaryContainer.withAlpha(80),
                      borderRadius: cardShape.borderRadius / 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.settings_manageProfile,
                          style: TextStyle(
                            color: s.primaryDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Symbols.arrow_forward,
                          size: 14,
                          color: s.primaryDark,
                          weight: 600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
