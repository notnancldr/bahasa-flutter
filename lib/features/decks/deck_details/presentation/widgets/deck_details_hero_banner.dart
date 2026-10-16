import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Hero header banner for the Deck Details page displaying the country flag
/// floating above a sky-blue gradient banner with starburst decorations,
/// the deck's title, and its difficulty badge.
class DeckDetailsHeroBanner extends StatelessWidget {
  /// Deck metadata to render.
  final DeckItem deck;

  /// Creates a [DeckDetailsHeroBanner].
  const DeckDetailsHeroBanner({super.key, required this.deck});

  static const String _starburstSvg = '''
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M83.3624 21.5934C88.6304 12.8022 101.37 12.8022 106.638 21.5934L112.562 31.4799C115.634 36.6068 121.7 39.1192 127.497 37.6663L138.677 34.8647C148.619 32.3734 157.627 41.3813 155.135 51.3227L152.334 62.5026C150.881 68.3003 153.393 74.3659 158.52 77.4381L168.407 83.3624C177.198 88.6304 177.198 101.37 168.407 106.638L158.52 112.562C153.393 115.634 150.881 121.7 152.334 127.497L155.135 138.677C157.627 148.619 148.619 157.627 138.677 155.135L127.497 152.334C121.7 150.881 115.634 153.393 112.562 158.52L106.638 168.407C101.37 177.198 88.6304 177.198 83.3624 168.407L77.4381 158.52C74.3659 153.393 68.3003 150.881 62.5026 152.334L51.3228 155.135C41.3814 157.627 32.3734 148.619 34.8647 138.677L37.6663 127.497C39.1192 121.7 36.6068 115.634 31.4799 112.562L21.5934 106.638C12.8022 101.37 12.8022 88.6304 21.5934 83.3624L31.4798 77.4381C36.6068 74.3659 39.1192 68.3003 37.6663 62.5026L34.8647 51.3228C32.3734 41.3814 41.3813 32.3734 51.3227 34.8647L62.5026 37.6663C68.3003 39.1192 74.3659 36.6068 77.4381 31.4799L83.3624 21.5934Z" fill="#5BA6C4" fill-opacity="0.35"/>
    </svg>
  ''';

  String _resolveDifficultyLabel(BuildContext context, String difficulty) {
    final WidgetVars(:l) = WidgetVars.of(context);
    return switch (difficulty.toLowerCase()) {
      'beginner' => l.deck_gen_diff_beginner.toUpperCase(),
      'expert' => l.deck_gen_diff_expert.toUpperCase(),
      _ => l.deck_gen_diff_intermediate.toUpperCase(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);
    final difficultyLabel = _resolveDifficultyLabel(context, deck.difficulty);

    return SizedBox(
      height: 196,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Lower gradient banner
          Positioned(
            top: 22,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFD6EEF8), Color(0xFF5AB7DA)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Top-right decorative starburst
                    Positioned(
                      right: -12,
                      top: 6,
                      child: SvgPicture.string(
                        _starburstSvg,
                        width: 96,
                        height: 96,
                      ),
                    ),
                    // Bottom-center decorative starburst
                    Positioned(
                      left: 72,
                      bottom: -48,
                      child: SvgPicture.string(
                        _starburstSvg,
                        width: 140,
                        height: 140,
                      ),
                    ),
                    // Deck title and difficulty badge
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deck.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: t.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: AppColors.mainText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              difficultyLabel,
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.6,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating white flag card at top center
          Positioned(
            top: 0,
            child: Container(
              width: 176,
              height: 112,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CountryFlag.fromLanguageCode(
                    deck.language,
                    theme: const ImageTheme(
                      width: 140,
                      height: 86,
                      shape: RoundedRectangle(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
