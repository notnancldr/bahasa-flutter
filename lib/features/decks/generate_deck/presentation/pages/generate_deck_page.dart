import 'dart:async';

import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/step_page_switcher.dart';
import 'package:bahasa/core/widgets/step_progress_header.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../bloc/generate_deck_bloc.dart';
import '../bloc/generate_deck_event.dart';
import '../bloc/generate_deck_state.dart';
import '../widgets/deck_generation_country_step.dart';
import '../widgets/deck_generation_description_step.dart';
import '../widgets/deck_generation_difficulty_step.dart';
import '../widgets/deck_generation_error_view.dart';
import '../widgets/deck_generation_name_step.dart';
import '../widgets/deck_generation_progress_view.dart';
import '../widgets/deck_generation_review_step.dart';

/// Full-screen wizard for AI deck generation.
class GenerateDeckPage extends StatelessWidget {
  final GenerateDeckBloc? bloc;

  const GenerateDeckPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: const _GenerateDeckView());
    }

    try {
      context.read<GenerateDeckBloc>();
      return const _GenerateDeckView();
    } catch (_) {
      return BlocProvider(
        create: (_) => DecksDependencies.createGenerateDeckBloc(),
        child: const _GenerateDeckView(),
      );
    }
  }
}

class _GenerateDeckView extends StatefulWidget {
  const _GenerateDeckView();

  @override
  State<_GenerateDeckView> createState() => _GenerateDeckViewState();
}

class _GenerateDeckViewState extends State<_GenerateDeckView> {
  late final SettingsRepository _settingsRepository;
  bool _canGenerateOnline = true;
  bool _isOnlineModel = true;
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsDependencies.createSettingsRepository();
    _checkLimitAndStartTimer();
  }

  Future<void> _checkLimitAndStartTimer() async {
    final aiModel = await _settingsRepository.getAiModelPreference();
    final canGenerate = await _settingsRepository.canGenerateOnlineDeckToday();

    if (mounted) {
      setState(() {
        _isOnlineModel = aiModel == AiModelType.online;
        _canGenerateOnline = canGenerate;
      });
    }

    if (_isOnlineModel && !_canGenerateOnline) {
      _updateRemainingTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemainingTime();
      });
    }
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final remaining = nextMidnight.difference(now);

    if (mounted) {
      setState(() {
        _remainingTime = remaining.isNegative ? Duration.zero : remaining;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours}j ${minutes}m ${seconds}d';
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return BlocConsumer<GenerateDeckBloc, GenerateDeckState>(
      listener: (context, state) {
        if (state is GenerateDeckSuccessState) {
          context.go(AppRoutes.deck);
        }
      },
      builder: (context, state) {
        final bloc = context.read<GenerateDeckBloc>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: switch (state) {
                GenerateDeckWizardState() => _buildWizard(context, state, bloc),
                GenerateDeckInProgressState(
                  :final collectedCards,
                  :final totalCards,
                  :final isLocalAi,
                ) => Column(
                  children: [
                    Text(
                      l.deck_gen_progress_header,
                      style: t.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: c.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DeckGenerationProgressView(
                        collectedCards: collectedCards,
                        totalCards: totalCards,
                        isLocalAi: isLocalAi,
                        onRunInBackground: () => context.go(AppRoutes.deck),
                      ),
                    ),
                  ],
                ),
                GenerateDeckErrorState(:final errorMessage) => Column(
                  children: [
                    Text(
                      l.deck_gen_progress_header,
                      style: t.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: c.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DeckGenerationErrorView(
                        errorMessage: errorMessage,
                        onBackToHome: () => context.go(AppRoutes.home),
                      ),
                    ),
                  ],
                ),
                GenerateDeckSuccessState() => const SizedBox.shrink(),
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWizard(
    BuildContext context,
    GenerateDeckWizardState state,
    GenerateDeckBloc bloc,
  ) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isReviewStep = state.step == 4;
    final isLimitBlocked = _isOnlineModel && !_canGenerateOnline;
    final formattedTime = _formatTime(_remainingTime);

    return PopScope(
      canPop: state.step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          bloc.add(const PreviousStepRequested());
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Navigation / Progress
          if (!isReviewStep)
            StepProgressHeader(
              current: state.step,
              total: 4,
              title: l.deck_gen_appbar_title,
              onBack: () {
                if (state.step == 0) {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                } else {
                  bloc.add(const PreviousStepRequested());
                }
              },
            )
          else
            Row(
              children: [
                CircleBackButton(
                  onPressed: () => bloc.add(const PreviousStepRequested()),
                ),
                Expanded(
                  child: Text(
                    l.deck_gen_appbar_title,
                    style: t.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          const SizedBox(height: 16),

          // Top Limit Banner if Online AI Limit Blocked
          if (isLimitBlocked) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF87171), width: 1.2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Symbols.schedule,
                    size: 20,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.deck_gen_limit_reached_title(formattedTime),
                      style: t.bodySmall?.copyWith(
                        color: const Color(0xFF991B1B),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Main Step Content
          Expanded(
            child: isReviewStep
                ? DeckGenerationReviewStep(
                    state: state,
                    onEditStep: (stepIdx) =>
                        bloc.add(JumpToStepRequested(stepIdx)),
                    onCreateDeck: () =>
                        bloc.add(const SubmitGenerationRequested()),
                    onCancel: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  )
                : Column(
                    children: [
                      Expanded(
                        child: StepPageSwitcher(
                          currentStep: state.step,
                          child: switch (state.step) {
                            0 => DeckGenerationNameStep(
                              key: const ValueKey('gen-name-step'),
                              initialValue: state.name,
                              onChanged: (val) =>
                                  bloc.add(DeckNameChanged(val)),
                            ),
                            1 => DeckGenerationCountryStep(
                              key: const ValueKey('gen-country-step'),
                              selectedLanguage: state.language,
                              onLanguageSelected: (val) =>
                                  bloc.add(DeckCountryChanged(val)),
                            ),
                            2 => DeckGenerationDifficultyStep(
                              key: const ValueKey('gen-difficulty-step'),
                              selectedDifficulty: state.difficulty,
                              onDifficultySelected: (val) =>
                                  bloc.add(DeckDifficultyChanged(val)),
                            ),
                            3 => DeckGenerationDescriptionStep(
                              key: const ValueKey('gen-desc-step'),
                              initialValue: state.description,
                              onChanged: (val) =>
                                  bloc.add(DeckDescriptionChanged(val)),
                            ),
                            _ => const SizedBox.shrink(),
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      EmbossedButton(
                        isLimitBlocked
                            ? l.deck_gen_limit_countdown_button(formattedTime)
                            : l.deck_continue,
                        onPressed: (!isLimitBlocked && state.canProceedToNext)
                            ? () => bloc.add(const NextStepRequested())
                            : null,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
