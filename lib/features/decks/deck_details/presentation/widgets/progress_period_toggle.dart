import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

import '../bloc/deck_progress_state.dart';

/// Segmented pill toggle switching between `Bulan` (Monthly Bar Chart)
/// and `Tahun` (Calendar Heatmap) on the Deck Progress page.
class ProgressPeriodToggle extends StatelessWidget {
  /// Currently active period tab.
  final DeckProgressPeriodTab activeTab;

  /// Callback invoked when the user selects a tab.
  final ValueChanged<DeckProgressPeriodTab> onTabSelected;

  /// Creates a [ProgressPeriodToggle].
  const ProgressPeriodToggle({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :l) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.outline, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegmentButton(
              label: l.deck_progress_tab_month,
              isSelected: activeTab == DeckProgressPeriodTab.month,
              onPressed: () => onTabSelected(DeckProgressPeriodTab.month),
            ),
          ),
          Expanded(
            child: _ToggleSegmentButton(
              label: l.deck_progress_tab_year,
              isSelected: activeTab == DeckProgressPeriodTab.year,
              onPressed: () => onTabSelected(DeckProgressPeriodTab.year),
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
        minimumSize: const Size.fromHeight(34),
        padding: const EdgeInsets.symmetric(vertical: 6),
        side: isSelected
            ? const BorderSide(color: AppColors.primaryDark, width: 1)
            : BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: t.labelMedium?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: isSelected ? AppColors.primaryDark : c.onSurfaceVariant,
        ),
      ),
    );
  }
}
