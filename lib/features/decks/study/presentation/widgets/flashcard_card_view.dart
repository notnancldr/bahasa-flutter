import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Interactive 3D Flip Flashcard container that rotates between the Question face
/// (`Pertanyaan`) and the Answer face (`Jawaban`) using `flip_card`.
class FlashcardCardView extends StatefulWidget {
  /// The vocabulary card to display.
  final DeckCardItem card;

  /// Whether the card is currently flipped to the Answer side.
  final bool isFlipped;

  /// Callback invoked when the card surface is flipped.
  final VoidCallback onFlip;

  /// Creates a [FlashcardCardView].
  const FlashcardCardView({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  State<FlashcardCardView> createState() => _FlashcardCardViewState();
}

class _FlashcardCardViewState extends State<FlashcardCardView> {
  late final FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  void didUpdateWidget(covariant FlashcardCardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.idCard == widget.card.idCard &&
        oldWidget.isFlipped != widget.isFlipped) {
      _controller.toggleCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: FlipCard(
        key: ValueKey(widget.card.idCard),
        controller: _controller,
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL,
        speed: 350,
        front: _QuestionCardFace(card: widget.card),
        back: _AnswerCardFace(card: widget.card),
      ),
    );
  }
}

class _QuestionCardFace extends StatelessWidget {
  final DeckCardItem card;

  const _QuestionCardFace({required this.card});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l.flashcard_question_label,
            style: t.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.onSurfaceVariant,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.translation,
                  textAlign: TextAlign.center,
                  style: t.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    color: c.onSurface,
                  ),
                ),
                if (card.phoneticLang.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    card.phoneticLang,
                    textAlign: TextAlign.center,
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.cached,
                size: 16,
                color: c.onSurfaceVariant.withAlpha(180),
              ),
              const SizedBox(width: 6),
              Text(
                l.flashcard_tap_to_flip,
                style: t.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.onSurfaceVariant.withAlpha(190),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerCardFace extends StatelessWidget {
  final DeckCardItem card;

  const _AnswerCardFace({required this.card});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);
    final subtitleParts = <String>[
      if (card.translation.trim().isNotEmpty) card.translation.trim(),
      if (card.phoneticLang.trim().isNotEmpty) card.phoneticLang.trim(),
    ];

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l.flashcard_answer_label,
            style: t.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.onSurfaceVariant,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.defaultLanguage,
                  textAlign: TextAlign.center,
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: c.onSurface,
                  ),
                ),
                if (subtitleParts.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitleParts.join(' \u2022 '),
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (card.additionalContext.trim().isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.outline, width: 1),
              ),
              child: Text(
                card.additionalContext,
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(
                  fontSize: 11.5,
                  height: 1.4,
                  color: c.onSurfaceVariant,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
