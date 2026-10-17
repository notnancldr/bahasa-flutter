import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/flame_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../bloc/multiplayer_state.dart';
import '../widgets/multiplayer_star_grid.dart';

/// Completion screen displayed to both host and guesser upon finishing all 10 questions.
class MultiplayerCompletePage extends StatelessWidget {
  const MultiplayerCompletePage({super.key});

  static String _formatDuration(int durationMs) {
    final totalSeconds = (durationMs / 1000).round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes}m ${seconds}d';
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MultiplayerBloc, MultiplayerState>(
      builder: (context, state) {
        final outcomes = state.game.outcomes;
        final correctCount = state.game.correctCount;
        final totalQuestions = state.game.totalQuestions;
        final durationText = _formatDuration(state.game.durationMs);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              context.read<MultiplayerBloc>().add(
                const LeaveMultiplayerEvent(),
              );
              context.go(AppRoutes.multiplayer);
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Big Flame Illustration
                    Center(
                      child: const FlameIcon(streakCount: 1, size: 140)
                          .animate()
                          .scale(duration: 400.ms, curve: Curves.easeOutBack)
                          .fadeIn(duration: 300.ms),
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Text(
                      l.multiplayer_complete_title,
                      textAlign: TextAlign.center,
                      style: t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    )
                        .animate()
                        .slideY(
                          begin: 0.3,
                          end: 0.0,
                          duration: 350.ms,
                          delay: 150.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn(delay: 150.ms),

                    const Spacer(flex: 2),

                    // Star grid (10 questions)
                    MultiplayerStarGrid(
                      outcomes: outcomes,
                      totalQuestions: totalQuestions,
                    )
                        .animate()
                        .scale(
                          delay: 250.ms,
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(delay: 250.ms),

                    const Spacer(flex: 3),

                    // Divider and stats row
                    Divider(
                      color: isDark
                          ? const Color(0xFF2E3846)
                          : const Color(0xFFE2E8F0),
                      height: 1,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        // Jawaban Tepat
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                l.multiplayer_complete_correct_count(
                                  correctCount,
                                  totalQuestions,
                                ),
                                style: t.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.multiplayer_complete_correct_label,
                                style: t.bodySmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Vertical separator
                        Container(
                          width: 1,
                          height: 36,
                          color: isDark
                              ? const Color(0xFF2E3846)
                              : const Color(0xFFE2E8F0),
                        ),

                        // Waktu Aktif Sesi
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                durationText,
                                style: t.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.multiplayer_complete_time_label,
                                style: t.bodySmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .slideY(
                          begin: 0.3,
                          end: 0.0,
                          delay: 550.ms,
                          duration: 350.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn(delay: 550.ms),

                    const SizedBox(height: 28),

                    // Kembali Button
                    SizedBox(
                      width: double.infinity,
                      child: EmbossedButton(
                        l.multiplayer_back_button,
                        type: EmbossedButtonType.filled,
                        onPressed: () {
                          context.read<MultiplayerBloc>().add(
                            const LeaveMultiplayerEvent(),
                          );
                          context.go(AppRoutes.multiplayer);
                        },
                      ),
                    )
                        .animate()
                        .slideY(
                          begin: 0.4,
                          end: 0.0,
                          delay: 700.ms,
                          duration: 350.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn(delay: 700.ms),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
