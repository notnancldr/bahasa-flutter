import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingsProfileCard extends StatelessWidget {
  final VoidCallback onManageProfile;

  const SettingsProfileCard({
    super.key,
    required this.onManageProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        String username = 'Rizky_23';
        if (state is AccountLoaded) {
          username = state.profile.username.isNotEmpty ? state.profile.username : username;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2630) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF2C3847) : const Color(0xFFEFF2F5),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6EFF8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.person,
                  color: Color(0xFF4C8A9E),
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
                      'Pelajar Aktif',
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
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Kelola profil',
                        style: TextStyle(
                          color: Color(0xFF437D91),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Symbols.arrow_forward,
                        size: 14,
                        color: Color(0xFF437D91),
                        weight: 600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

