import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Card widget showing a deck recommendation or least active deck
/// with a pill badge, deck title, last studied relative time, and an "Ulas" action button.
class ReviewRecommendationCard extends StatelessWidget {
  /// Category badge label (e.g. 'Jarang Dipelajari').
  final String tag;

  /// Deck title (e.g. 'Tata Bahasa Modul 2').
  final String title;

  /// Relative study time (e.g. 'Terakhir dipelajari 12 hari lalu.').
  final String subtitle;

  /// Callback when the card or 'Ulas' action button is pressed.
  final VoidCallback onReview;

  const ReviewRecommendationCard({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l, :isDark) = WidgetVars.of(context);

    final cardBgColor = isDark ? AppColors.darkSurfaceElevated : Colors.white;
    final borderColor = isDark
        ? AppColors.darkOutline
        : const Color(0xFFECECEC);

    final tagBgColor = isDark
        ? const Color(0xFF1E3A45)
        : const Color(0xFFE8F4F8);
    final tagTextColor = isDark
        ? const Color(0xFF7FC1D9)
        : const Color(0xFF5B93AE);

    final buttonBgColor = isDark
        ? AppColors.darkPrimaryContainer
        : const Color(0xFFA2D2DF);
    final buttonTextColor = isDark
        ? AppColors.darkOnSurface
        : const Color(0xFF38687D);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Tag, Title, Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tagTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: t.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: c.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(width: 12),
          // Right side: 'Ulas' pill action button with play arrow
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onReview,
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: buttonBgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.home_reviewButton,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: buttonTextColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.play_arrow, size: 16, color: buttonTextColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
