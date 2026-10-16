import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_progress_data.dart';
import '../bloc/deck_progress_state.dart';

/// Modal bottom sheet displaying period statistics (`Card`, `Akurat`, `Aktif`)
/// and the Top 3 Weakest Cards (`3 Kartu Paling Lemah`) for a selected date or month.
class PeriodDetailBottomSheet extends StatelessWidget {
  /// Selected period detail to render.
  final SelectedPeriodDetail detail;

  /// Creates a [PeriodDetailBottomSheet].
  const PeriodDetailBottomSheet({super.key, required this.detail});

  /// Shows the [PeriodDetailBottomSheet] modal.
  static Future<void> show(BuildContext context, SelectedPeriodDetail detail) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PeriodDetailBottomSheet(detail: detail),
    );
  }

  static const String _starburstBadgeSvg = '''
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M83.3624 21.5934C88.6304 12.8022 101.37 12.8022 106.638 21.5934L112.562 31.4799C115.634 36.6068 121.7 39.1192 127.497 37.6663L138.677 34.8647C148.619 32.3734 157.627 41.3813 155.135 51.3227L152.334 62.5026C150.881 68.3003 153.393 74.3659 158.52 77.4381L168.407 83.3624C177.198 88.6304 177.198 101.37 168.407 106.638L158.52 112.562C153.393 115.634 150.881 121.7 152.334 127.497L155.135 138.677C157.627 148.619 148.619 157.627 138.677 155.135L127.497 152.334C121.7 150.881 115.634 153.393 112.562 158.52L106.638 168.407C101.37 177.198 88.6304 177.198 83.3624 168.407L77.4381 158.52C74.3659 153.393 68.3003 150.881 62.5026 152.334L51.3228 155.135C41.3814 157.627 32.3734 148.619 34.8647 138.677L37.6663 127.497C39.1192 121.7 36.6068 115.634 31.4799 112.562L21.5934 106.638C12.8022 101.37 12.8022 88.6304 21.5934 83.3624L31.4798 77.4381C36.6068 74.3659 39.1192 68.3003 37.6663 62.5026L34.8647 51.3228C32.3734 41.3814 41.3813 32.3734 51.3227 34.8647L62.5026 37.6663C68.3003 39.1192 74.3659 36.6068 77.4381 31.4799L83.3624 21.5934Z" fill="url(#badge_grad)"/>
    <defs>
      <linearGradient id="badge_grad" x1="20" y1="20" x2="170" y2="170" gradientUnits="userSpaceOnUse">
        <stop stop-color="#5EB6D8"/>
        <stop offset="1" stop-color="#3793B7"/>
      </linearGradient>
    </defs>
    </svg>
  ''';

  String _formatPeriodTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    try {
      if (detail.isMonth) {
        return DateFormat('MMMM yyyy', locale).format(detail.date);
      }
      return DateFormat('EEEE, d MMMM yyyy', locale).format(detail.date);
    } catch (_) {
      return '${detail.date.day}/${detail.date.month}/${detail.date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.outline,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Symbols.close,
                    size: 22,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ),

              // Starburst badge with day/month number
              Center(
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.string(
                        _starburstBadgeSvg,
                        width: 112,
                        height: 112,
                      ),
                      Text(
                        '${detail.badgeNumber}',
                        style: t.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Formatted date title
              Text(
                _formatPeriodTitle(context),
                textAlign: TextAlign.center,
                style: t.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: c.onSurface,
                ),
              ),
              const SizedBox(height: 18),

              // 3 metric boxes row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PeriodMetricBox(
                    value: '${detail.cardsPracticed}',
                    label: l.deck_progress_metric_card,
                  ),
                  const SizedBox(width: 14),
                  _PeriodMetricBox(
                    value: '${detail.accuracyPercent}%',
                    label: l.deck_progress_metric_accurate,
                  ),
                  const SizedBox(width: 14),
                  _PeriodMetricBox(
                    value: '${detail.activeMinutes}m',
                    label: l.deck_progress_metric_active,
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Top 3 Weakest Cards header
              Text(
                l.deck_progress_weakest_cards_title,
                textAlign: TextAlign.center,
                style: t.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              if (detail.weakestCards.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l.deck_progress_weakest_empty,
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
                  ),
                )
              else
                ...List.generate(detail.weakestCards.length, (index) {
                  final item = detail.weakestCards[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _WeakCardRow(
                      rank: index + 1,
                      item: item,
                      isHighlighted: index == 0,
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodMetricBox extends StatelessWidget {
  final String value;
  final String label;

  const _PeriodMetricBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: const Color(0xFF5D3A1A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: t.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: const Color(0xFF7A5230),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeakCardRow extends StatelessWidget {
  final int rank;
  final WeakCardSummary item;
  final bool isHighlighted;

  const _WeakCardRow({
    required this.rank,
    required this.item,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted ? c.onSurfaceVariant : c.outline,
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: t.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.mainText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.card.translation,
                  style: t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: c.onSurface,
                  ),
                ),
                Text(
                  item.card.defaultLanguage,
                  style: t.bodySmall?.copyWith(
                    fontSize: 11,
                    color: c.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      l.deck_progress_wrong_count(item.wrongCount),
                      style: t.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: c.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.deck_progress_accurate_percent(item.accuracyPercent),
                      style: t.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
