import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Main multiplayer tab page where users can choose to host a new room or join an existing room.
class MultiplayerMainPage extends StatelessWidget {
  const MultiplayerMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.multiplayer_title,
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: Icon(
                Symbols.history,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            tooltip: l.multiplayer_history_title,
            onPressed: () => context.push(AppRoutes.multiplayerHistory),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Hero Illustration
              Container(
                width: 140,
                height: 100,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E3A4A)
                      : const Color(0xFFBCE7F0),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Icon(
                    Symbols.groups,
                    size: 56,
                    color: isDark
                        ? const Color(0xFFA8D5E2)
                        : const Color(0xFF1D4A5C),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title and Description
              Text(
                l.multiplayer_banner_title,
                textAlign: TextAlign.center,
                style: t.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: c.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l.multiplayer_banner_desc,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Option 1: Buat Ruangan Baru (Host)
              _ActionCard(
                icon: Symbols.add,
                iconBgColor: isDark
                    ? const Color(0xFF4A3425)
                    : const Color(0xFFFFE0B2),
                iconColor: isDark
                    ? const Color(0xFFFFCC80)
                    : const Color(0xFF8D4E16),
                title: l.multiplayer_create_room,
                subtitle: l.multiplayer_create_room_desc,
                onTap: () {
                  context.push(
                    AppRoutes.multiplayerRoom,
                    extra: {'isHost': true},
                  );
                },
              ),

              const SizedBox(height: 16),

              // Option 2: Gabung ruangan (Guesser)
              _ActionCard(
                icon: Symbols.search,
                iconBgColor: isDark
                    ? const Color(0xFF352B4E)
                    : const Color(0xFFEDE7F6),
                iconColor: isDark
                    ? const Color(0xFFD1C4E9)
                    : const Color(0xFF5E35B1),
                title: l.multiplayer_join_room,
                subtitle: l.multiplayer_join_room_desc,
                onTap: () {
                  context.push(
                    AppRoutes.multiplayerRoom,
                    extra: {'isHost': false},
                  );
                },
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF1E2630) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF2E3846) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: t.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Symbols.chevron_right,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
