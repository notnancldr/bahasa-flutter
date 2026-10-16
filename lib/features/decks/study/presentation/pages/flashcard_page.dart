import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/step_progress_header.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/flashcard_bloc.dart';
import '../bloc/flashcard_event.dart';
import '../bloc/flashcard_state.dart';
import '../widgets/flashcard_assessment_row.dart';
import '../widgets/flashcard_card_view.dart';
import '../widgets/flashcard_complete_view.dart';

/// Full-screen Flashcard study session page.
class FlashcardPage extends StatelessWidget {
  /// Target deck identifier.
  final String deckId;

  /// Optional [FlashcardBloc] override for testing.
  final FlashcardBloc? bloc;

  /// Creates a [FlashcardPage].
  const FlashcardPage({super.key, required this.deckId, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashcardBloc>(
      create: (_) =>
          (bloc ?? DecksDependencies.createFlashcardBloc())
            ..add(StartFlashcardSessionEvent(deckId)),
      child: _FlashcardSessionView(deckId: deckId),
    );
  }
}

class _FlashcardSessionView extends StatelessWidget {
  final String deckId;

  const _FlashcardSessionView({required this.deckId});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FlashcardBloc, FlashcardState>(
          builder: (context, state) {
            return switch (state) {
              FlashcardLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              FlashcardError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.read<FlashcardBloc>().add(
                          StartFlashcardSessionEvent(deckId),
                        ),
                        child: Text(l.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
              FlashcardCompleted(:final result) => FlashcardCompleteView(
                result: result,
                onFinish: () => context.pop(),
              ),
              FlashcardInProgress(
                :final currentCard,
                :final currentIndex,
                :final totalCards,
                :final isFlipped,
              ) =>
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        l.flashcard_title,
                        textAlign: TextAlign.center,
                        style: t.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: c.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress bar
                      StepProgressBar(current: currentIndex, total: totalCards),
                      const SizedBox(height: 20),

                      // Instruction prompt
                      Text(
                        l.flashcard_instruction,
                        style: t.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: c.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card index badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: c.outline, width: 1),
                          ),
                          child: Text(
                            l.flashcard_card_progress(
                              currentIndex + 1,
                              totalCards,
                            ),
                            style: t.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: c.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Main Flashcard
                      Expanded(
                        child: SingleChildScrollView(
                          child: FlashcardCardView(
                            card: currentCard,
                            isFlipped: isFlipped,
                            onFlip: () => context.read<FlashcardBloc>().add(
                              const FlipFlashcardEvent(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bottom Action Area: Flip button OR Assessment buttons
                      if (!isFlipped)
                        EmbossedButton(
                          l.flashcard_flip_button,
                          onPressed: () => context.read<FlashcardBloc>().add(
                            const FlipFlashcardEvent(),
                          ),
                        )
                      else
                        FlashcardAssessmentRow(
                          onNotMemorized: () =>
                              context.read<FlashcardBloc>().add(
                                const AnswerFlashcardEvent(isMemorized: false),
                              ),
                          onMemorized: () => context.read<FlashcardBloc>().add(
                            const AnswerFlashcardEvent(isMemorized: true),
                          ),
                        ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
