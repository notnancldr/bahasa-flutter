import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Interactive list tile representing a recent study activity on a deck.
///
/// Features a circular icon with tinted background, deck title, card count & time subtitle,
/// and a chevron navigation indicator.
class RecentActivityTile extends StatelessWidget {
  /// The title of the deck or activity (e.g. 'Kosakata JLPT N5').
  final String title;

  /// The subtitle text showing card count and relative time (e.g. '15 kartu • 2 jam lalu').
  final String subtitle;

  /// Custom icon representing the activity type or topic.
  final IconData icon;

  /// The accent color used for the icon and its tinted background.
  final Color color;

  /// Callback when the activity row is tapped.
  final VoidCallback onTap;

  const RecentActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :isDark) = WidgetVars.of(context);

    final cardBgColor = isDark ? AppColors.darkSurfaceElevated : Colors.white;
    final borderColor = isDark
        ? AppColors.darkOutline
        : const Color(0xFFECECEC);

    final iconBgColor = color.withAlpha(isDark ? 55 : 45);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Circular avatar badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 14),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: t.titleSmall?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: c.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: t.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8A979D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Chevron indicator
              const Icon(
                Symbols.chevron_right,
                size: 20,
                color: Color(0xFF9EAAB0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
