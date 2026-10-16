import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/deck_history_period.dart';

/// Segmented pill toggle switching between "Minggu ini", "Bulan ini", and "Tahun ini".
class DeckHistoryPeriodToggle extends StatelessWidget {
  /// Currently selected period filter.
  final DeckHistoryPeriod activePeriod;

  /// Callback dispatched when user taps another period tab.
  final ValueChanged<DeckHistoryPeriod> onPeriodChanged;

  /// Creates a [DeckHistoryPeriodToggle].
  const DeckHistoryPeriodToggle({
    super.key,
    required this.activePeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :l) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegmentButton(
              label: l.deck_history_period_week,
              isSelected: activePeriod == DeckHistoryPeriod.week,
              onPressed: () => onPeriodChanged(DeckHistoryPeriod.week),
            ),
          ),
          Expanded(
            child: _ToggleSegmentButton(
              label: l.deck_history_period_month,
              isSelected: activePeriod == DeckHistoryPeriod.month,
              onPressed: () => onPeriodChanged(DeckHistoryPeriod.month),
            ),
          ),
          Expanded(
            child: _ToggleSegmentButton(
              label: l.deck_history_period_year,
              isSelected: activePeriod == DeckHistoryPeriod.year,
              onPressed: () => onPeriodChanged(DeckHistoryPeriod.year),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ToggleSegmentButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c) = WidgetVars.of(context);

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
        foregroundColor: isSelected
            ? AppColors.primaryDark
            : c.onSurfaceVariant,
        elevation: 0,
        minimumSize: const Size.fromHeight(36),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        side: isSelected
            ? const BorderSide(color: AppColors.primaryDark, width: 0.8)
            : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: t.labelMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          fontSize: 12.5,
          color: isSelected ? AppColors.primaryDark : c.onSurfaceVariant,
        ),
      ),
    );
  }
}
