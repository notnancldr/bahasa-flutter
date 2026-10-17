import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/step_progress_header.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/quiz_question.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/quiz_complete_view.dart';
import '../widgets/quiz_context_guess_view.dart';
import '../widgets/quiz_feedback_sheet.dart';
import '../widgets/quiz_jumble_words_view.dart';
import '../widgets/quiz_multiple_choice_view.dart';

/// Full-screen Quiz study session page supporting Multiple Choice (`translating`)
/// and Jumble Words (`writing`) questions, immediate feedback overlays,
/// and completion summary.
class QuizPage extends StatelessWidget {
  /// Target deck identifier.
  final String deckId;

  /// Optional [QuizBloc] override for testing.
  final QuizBloc? bloc;

  /// Creates a [QuizPage].
  const QuizPage({super.key, required this.deckId, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizBloc>(
      create: (_) =>
          (bloc ?? DecksDependencies.createQuizBloc())
            ..add(StartQuizSessionEvent(deckId)),
      child: _QuizSessionView(deckId: deckId),
    );
  }
}

class _QuizSessionView extends StatelessWidget {
  final String deckId;

  const _QuizSessionView({required this.deckId});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            return switch (state) {
              QuizLoading() => const Center(child: CircularProgressIndicator()),
              QuizError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.read<QuizBloc>().add(
                          StartQuizSessionEvent(deckId),
                        ),
                        child: Text(l.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
              QuizCompleted(:final result) => QuizCompleteView(
                result: result,
                onFinish: () => context.pop(),
              ),
              QuizInProgress(
                :final currentQuestion,
                :final currentIndex,
                :final totalQuestions,
                :final selectedOption,
                :final selectedWordIndices,
                :final feedbackStatus,
                :final canCheckAnswer,
              ) =>
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          Text(
                            l.quiz_title,
                            textAlign: TextAlign.center,
                            style: t.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: c.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Progress bar
                          StepProgressBar(
                            current: currentIndex,
                            total: totalQuestions,
                          ),
                          const SizedBox(height: 20),

                          // Question body
                          Expanded(
                            child: SingleChildScrollView(
                              child: switch (currentQuestion.type) {
                                QuizQuestionType.multipleChoice =>
                                  QuizMultipleChoiceView(
                                    question: currentQuestion,
                                    selectedOption: selectedOption,
                                    onSelectOption: (opt) => context
                                        .read<QuizBloc>()
                                        .add(SelectQuizOptionEvent(opt)),
                                  ),
                                QuizQuestionType.contextGuess =>
                                  QuizContextGuessView(
                                    question: currentQuestion,
                                    selectedOption: selectedOption,
                                    onSelectOption: (opt) => context
                                        .read<QuizBloc>()
                                        .add(SelectQuizOptionEvent(opt)),
                                  ),
                                QuizQuestionType.jumbleWords =>
                                  QuizJumbleWordsView(
                                    question: currentQuestion,
                                    selectedWordIndices: selectedWordIndices,
                                    onToggleWordIndex: (idx) => context
                                        .read<QuizBloc>()
                                        .add(ToggleQuizJumbleWordEvent(idx)),
                                  ),
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Check Answer button
                          EmbossedButton(
                            l.quiz_check_answer_button,
                            onPressed: canCheckAnswer
                                ? () => context.read<QuizBloc>().add(
                                    const CheckQuizAnswerEvent(),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Feedback overlay sheet when an answer is checked
                    if (feedbackStatus != QuizFeedbackStatus.none)
                      Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black26,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: QuizFeedbackSheet(
                              question: currentQuestion,
                              isCorrect:
                                  feedbackStatus == QuizFeedbackStatus.correct,
                              onContinue: () => context.read<QuizBloc>().add(
                                const NextQuizQuestionEvent(),
                              ),
                            )
                                .animate()
                                .slideY(
                                  begin: 1.0,
                                  end: 0.0,
                                  duration: 350.ms,
                                  curve: Curves.easeOutCubic,
                                )
                                .fadeIn(duration: 200.ms),
                          ),
                        ).animate().fadeIn(duration: 200.ms),
                      ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}
