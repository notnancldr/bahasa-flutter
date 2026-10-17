import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/decks/generate_deck/presentation/bloc/generate_deck_state.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

/// In-progress placeholder card displayed on the Deck Compilation page when
/// a deck is being generated in the background.
class GeneratingDeckPlaceholderCard extends StatelessWidget {
  final GenerateDeckInProgressState progressState;

  const GeneratingDeckPlaceholderCard({
    super.key,
    required this.progressState,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final subtitleText = progressState.isLocalAi && progressState.collectedCards > 0
        ? l.deck_gen_cards_collected_progress(
            progressState.collectedCards,
            progressState.totalCards,
          )
        : l.deck_gen_progress_title;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2630) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: c.primary.withAlpha(120),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Faded Flag / Background Illustration
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Opacity(
                opacity: 0.15,
                child: progressState.language.isNotEmpty
                    ? CountryFlag.fromLanguageCode(
                        progressState.language,
                      )
                    : Container(color: c.primaryContainer),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: c.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                c.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.deck_gen_in_progress_badge,
                            style: t.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              color: c.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Symbols.auto_awesome,
                      size: 20,
                      color: c.primary,
                    ),
                  ],
                ),

                const Spacer(),

                // Center Spinning Indicator
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: c.surface.withAlpha(200),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Title & Progress Subtitle
                Text(
                  progressState.deckName,
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: c.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleText,
                  style: t.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: c.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (cnt) => cnt.repeat(reverse: true)).fade(
          begin: 0.7,
          end: 1.0,
          duration: 1000.ms,
        );
  }
}
