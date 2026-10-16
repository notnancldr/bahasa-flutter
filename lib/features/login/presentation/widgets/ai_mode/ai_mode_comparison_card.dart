import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Row data model for comparing Online vs Local AI capabilities.
class _ComparisonRow {
  final String featureName;
  final bool onlineSupport;
  final bool localSupport;

  const _ComparisonRow({
    required this.featureName,
    required this.onlineSupport,
    required this.localSupport,
  });
}

/// Comparison table card presenting features between Online and Local AI processing.
class AiModeComparisonCard extends StatelessWidget {
  const AiModeComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    final rows = [
      _ComparisonRow(
        featureName: l.ai_feature_unlimited_generation,
        onlineSupport: false,
        localSupport: true,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_offline_use,
        onlineSupport: false,
        localSupport: true,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_private_storage,
        onlineSupport: false,
        localSupport: true,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_faster_process,
        onlineSupport: true,
        localSupport: false,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_broader_context,
        onlineSupport: true,
        localSupport: false,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_more_accurate,
        onlineSupport: true,
        localSupport: false,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_daily_limit,
        onlineSupport: true,
        localSupport: false,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_requires_internet,
        onlineSupport: true,
        localSupport: false,
      ),
      _ComparisonRow(
        featureName: l.ai_feature_data_training,
        onlineSupport: true,
        localSupport: false,
      ),
    ];

    const localColumnWidth = 60.0;
    const onlineColumnWidth = 60.0;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.outlineVariant.withAlpha(120), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Highlight column behind "Local"
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: localColumnWidth + 12,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5F8),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Table Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.ai_mode_feature_header,
                          style: t.labelMedium?.copyWith(
                            color: c.onSurfaceVariant.withAlpha(150),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: onlineColumnWidth,
                        child: Text(
                          l.ai_mode_online_header,
                          textAlign: TextAlign.center,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: c.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: localColumnWidth,
                        child: Text(
                          l.ai_mode_local_header,
                          textAlign: TextAlign.center,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: c.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Rows
                ...rows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            row.featureName,
                            style: t.bodySmall?.copyWith(
                              color: c.onSurface,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: onlineColumnWidth,
                          child: Center(
                            child: _buildCheckOrCross(row.onlineSupport),
                          ),
                        ),
                        SizedBox(
                          width: localColumnWidth,
                          child: Center(
                            child: _buildCheckOrCross(row.localSupport),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckOrCross(bool isChecked) {
    if (isChecked) {
      return const Icon(
        Symbols.check,
        color: Color(0xFF2E7D32),
        size: 22,
        weight: 700,
      );
    }
    return const Icon(
      Symbols.close,
      color: Color(0xFF78909C),
      size: 22,
      weight: 600,
    );
  }
}
