import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/step_progress_header.dart';
import 'package:bahasa/core/widgets/waiting_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../bloc/multiplayer_state.dart';
import '../widgets/multiplayer_option_card.dart';

/// Active game session page coordinating host question answering, clue elaboration,
/// guesser answering, instant feedback, and score progression.
class MultiplayerGamePage extends StatelessWidget {
  const MultiplayerGamePage({super.key});

  Future<void> _confirmLeave(BuildContext context) async {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.multiplayer_leave_confirm_title),
        content: Text(l.multiplayer_leave_confirm_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l.multiplayer_leave_confirm_no),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l.multiplayer_leave_confirm_yes),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<MultiplayerBloc>().add(const LeaveMultiplayerEvent());
      context.go(AppRoutes.multiplayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<MultiplayerBloc, MultiplayerState>(
      listener: (context, state) {
        if (state.phase == MultiplayerPhase.completed) {
          context.pushReplacement(AppRoutes.multiplayerComplete);
        } else if (state.phase == MultiplayerPhase.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Disconnected')),
          );
          context.go(AppRoutes.multiplayer);
        }
      },
      builder: (context, state) {
        final currentQ = state.game.currentQuestion;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              _confirmLeave(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: CircleBackButton(
                    onPressed: () => _confirmLeave(context),
                  ),
                ),
              ),
              title: Text(
                l.multiplayer_game_title,
                style: t.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Icon(
                      Symbols.history,
                      size: 20,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  tooltip: l.multiplayer_history_title,
                  onPressed: () => context.push(AppRoutes.multiplayerHistory),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // Segmented progress bar (10 segments)
                    StepProgressBar(
                      current: state.game.currentQuestionIndex,
                      total: state.game.totalQuestions,
                    ),
                    const SizedBox(height: 24),

                    // Game state content
                    Expanded(
                      child: currentQ == null
                          ? const Center(child: CircularProgressIndicator())
                          : _buildPhaseView(context, state),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhaseView(BuildContext context, MultiplayerState state) {
    final isHost = state.isHost;
    final phase = state.phase;

    // Guesser is kept on waiting screen during hostAnswering and hostWrongFeedback
    if (!isHost &&
        (phase == MultiplayerPhase.hostAnswering ||
            phase == MultiplayerPhase.hostWrongFeedback)) {
      return _buildGuesserWaitingView(context, state);
    }

    // Host wrong answer feedback
    if (isHost && phase == MultiplayerPhase.hostWrongFeedback) {
      return _buildHostWrongFeedbackView(context, state);
    }

    // Host answering turn
    if (isHost && phase == MultiplayerPhase.hostAnswering) {
      return _buildHostAnsweringView(context, state);
    }

    // Guesser turn: Host elaborates, Guesser picks option
    if (phase == MultiplayerPhase.guesserTurn) {
      return isHost
          ? _buildHostElaborateView(context, state)
          : _buildGuesserQuizView(context, state);
    }

    // Score feedback screen (+1 / -1)
    if (phase == MultiplayerPhase.scoreFeedback) {
      return _buildScoreFeedbackView(context, state);
    }

    return const Center(child: CircularProgressIndicator());
  }

  // 1. Host Answering View
  Widget _buildHostAnsweringView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:t) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = state.game.currentQuestion!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question prompt card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2E3846)
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan ${state.game.currentQuestionIndex + 1}',
                  style: t.labelMedium?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  q.prompt,
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4 Options
          ...q.options.map((option) {
            return MultiplayerOptionCard(
              text: option,
              onTap: () {
                context.read<MultiplayerBloc>().add(
                  SubmitHostAnswerEvent(option),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // 2. Guesser Waiting View (multiplayer_guesser_waiting.png)
  Widget _buildGuesserWaitingView(
    BuildContext context,
    MultiplayerState state,
  ) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hostName = state.game.hostPlayer?.name ?? 'Host';

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2630) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? const Color(0xFF2E3846) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isDark
                  ? const Color(0xFF4A3425)
                  : const Color(0xFFFFE0B2),
              child: Text(
                'P1',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFFFCC80)
                      : const Color(0xFF8D4E16),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.multiplayer_guesser_waiting_title(hostName),
              textAlign: TextAlign.center,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.multiplayer_guesser_waiting_desc(hostName),
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Host Wrong Answer Feedback View (multiplayer_wrongAns.png)
  Widget _buildHostWrongFeedbackView(
    BuildContext context,
    MultiplayerState state,
  ) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = state.game.currentQuestion!;
    final hostSelected = state.game.hostSelectedOption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Prompt Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2630) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2E3846)
                          : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pertanyaan ${state.game.currentQuestionIndex + 1}',
                        style: t.labelMedium?.copyWith(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        q.prompt,
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Options with feedback styling
                ...q.options.map((option) {
                  final isCorrect =
                      option.toLowerCase() == q.correctAnswer.toLowerCase();
                  final isWrong =
                      option.toLowerCase() == hostSelected?.toLowerCase() &&
                      !isCorrect;

                  return MultiplayerOptionCard(
                    text: option,
                    isCorrect: isCorrect,
                    isWrong: isWrong,
                  );
                }),
              ],
            ),
          ),
        ),

        // Bottom continue button
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            width: double.infinity,
            child: EmbossedButton(
              l.multiplayer_continue_button,
              type: EmbossedButtonType.filled,
              onPressed: () {
                context.read<MultiplayerBloc>().add(
                  const ContinueToNextQuestionEvent(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 4. Host Clue Elaboration View (multiplayer_host_elaborate.png)
  Widget _buildHostElaborateView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = state.game.currentQuestion!;
    final guesserName = state.game.guesserPlayer?.name ?? 'Penebak';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top empty card container matching design
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2630) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF2E3846) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
        ),

        const Spacer(flex: 2),

        // Center Clue Prompt
        Column(
          children: [
            Text(
              'Pertanyaan ${state.game.currentQuestionIndex + 1}',
              style: t.labelMedium?.copyWith(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '“${q.targetWord}”',
              textAlign: TextAlign.center,
              style: t.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              l.multiplayer_host_elaborate_prompt(guesserName),
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const Spacer(flex: 3),
      ],
    );
  }

  // 5. Guesser Quiz View (multiplayer_guesser_quiz.png)
  Widget _buildGuesserQuizView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = state.game.currentQuestion!;
    final hostName = state.game.hostPlayer?.name ?? 'Host';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top instruction box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2E3846)
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                l.multiplayer_guesser_listen_prompt(hostName),
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 4 Options
          ...q.options.map((option) {
            return MultiplayerOptionCard(
              text: option,
              onTap: () {
                context.read<MultiplayerBloc>().add(
                  SubmitGuesserAnswerEvent(option),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // 6. Score Feedback View (+1 / -1) (multiplayer_host_correntAns.png & multiplayer_guesser_correntAns.png)
  Widget _buildScoreFeedbackView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = state.game.lastScoreDelta > 0;
    final deltaText = isPositive
        ? l.multiplayer_score_plus
        : l.multiplayer_score_minus;
    final deltaColor = isPositive
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);
    final deltaBgColor = isPositive
        ? (isDark ? const Color(0xFF1E3A2A) : const Color(0xFFE8F5E9))
        : (isDark ? const Color(0xFF3E2020) : const Color(0xFFFFEBEE));

    return Column(
      children: [
        const Spacer(flex: 2),

        // Circle with +1 or -1
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: deltaBgColor,
            shape: BoxShape.circle,
            border: Border.all(color: deltaColor, width: 1.5),
          ),
          child: Center(
            child: Text(
              deltaText,
              style: TextStyle(
                color: deltaColor,
                fontWeight: FontWeight.w900,
                fontSize: 32,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          l.multiplayer_score_label,
          style: t.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 36,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          l.multiplayer_score_total,
          style: t.bodyMedium?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l.multiplayer_score_points(state.game.totalScore),
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),

        const Spacer(flex: 3),

        // Host has "Lanjutkan Soal" button; Guesser waits
        if (state.isHost) ...[
          SizedBox(
            width: double.infinity,
            child: EmbossedButton(
              l.multiplayer_continue_button,
              type: EmbossedButtonType.filled,
              onPressed: () {
                context.read<MultiplayerBloc>().add(
                  const ContinueToNextQuestionEvent(),
                );
              },
            ),
          ),
        ] else ...[
          Center(child: WaitingDots(color: c.primary)),
        ],

        const SizedBox(height: 12),
      ],
    );
  }
}
