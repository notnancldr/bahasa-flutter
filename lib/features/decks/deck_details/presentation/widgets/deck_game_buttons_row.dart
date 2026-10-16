import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Row of two pill buttons on the Deck Details page to launch the Quiz game
/// or the Flash Card game.
class DeckGameButtonsRow extends StatelessWidget {
  /// Callback invoked when the user taps "Mainkan Quiz".
  final VoidCallback? onPlayQuiz;

  /// Callback invoked when the user taps "Mainkan Flash Card".
  final VoidCallback? onPlayFlashcard;

  /// Creates a [DeckGameButtonsRow].
  const DeckGameButtonsRow({
    super.key,
    required this.onPlayQuiz,
    required this.onPlayFlashcard,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l) = WidgetVars.of(context);

    return Row(
      children: [
        Expanded(
          child: _GamePillButton(
            label: l.deck_details_play_quiz,
            backgroundColor: AppColors.success,
            iconBadgeColor: const Color(0xFFD9EED6),
            iconColor: AppColors.mainText,
            icon: Symbols.play_arrow,
            fillIcon: true,
            onPressed: onPlayQuiz,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _GamePillButton(
            label: l.deck_details_play_flashcard,
            backgroundColor: AppColors.secondary,
            iconBadgeColor: const Color(0xFFF9B277),
            iconColor: AppColors.mainText,
            icon: Symbols.style,
            fillIcon: false,
            onPressed: onPlayFlashcard,
          ),
        ),
      ],
    );
  }
}

class _GamePillButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color iconBadgeColor;
  final Color iconColor;
  final IconData icon;
  final bool fillIcon;
  final VoidCallback? onPressed;

  const _GamePillButton({
    required this.label,
    required this.backgroundColor,
    required this.iconBadgeColor,
    required this.iconColor,
    required this.icon,
    required this.fillIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.mainText,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBadgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              fill: fillIcon ? 1 : 0,
              weight: 700,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                height: 1.2,
                color: AppColors.mainText,
              ),
            ),
          ),
          const Icon(
            Symbols.chevron_right,
            size: 18,
            weight: 700,
            color: AppColors.mainText,
          ),
        ],
      ),
    );
  }
}
