import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/multiplayer_player.dart';

/// Card displaying connected player details in the multiplayer practice lobby.
class MultiplayerPlayerCard extends StatelessWidget {
  final MultiplayerPlayer player;

  const MultiplayerPlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final avatarBg = player.isHost
        ? (isDark ? const Color(0xFF4A3425) : const Color(0xFFFFE0B2))
        : (isDark ? const Color(0xFF352B4E) : const Color(0xFFD1C4E9));

    final avatarText = player.isHost
        ? (isDark ? const Color(0xFFFFCC80) : const Color(0xFF8D4E16))
        : (isDark ? const Color(0xFFD1C4E9) : const Color(0xFF5E35B1));

    final roleLabel = player.isHost
        ? l.multiplayer_lobby_role_host
        : l.multiplayer_lobby_role_guesser;

    final displayName = player.isHost ? '${player.name} (Host)' : player.name;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2630) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2E3846) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: avatarBg,
            child: Text(
              player.badgeText,
              style: TextStyle(
                color: avatarText,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            roleLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodySmall?.copyWith(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E3828) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              l.multiplayer_lobby_ready,
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
