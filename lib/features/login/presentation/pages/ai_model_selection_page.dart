import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/login/login_dependencies.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_event.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_state.dart';
import 'package:bahasa/features/login/presentation/widgets/ai_mode/ai_mode_comparison_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Full-screen view for selecting AI processing mode (Online vs Local).
class AiModelSelectionPage extends StatelessWidget {
  const AiModelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginDependencies.createAiOnboardingBloc(),
      child: const _AiModelSelectionView(),
    );
  }
}

class _AiModelSelectionView extends StatelessWidget {
  const _AiModelSelectionView();

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    return BlocConsumer<AiOnboardingBloc, AiOnboardingState>(
      listener: (context, state) {
        if (state is AiOnboardingFinishedState) {
          context.go(AppRoutes.home);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // Header Title
                  Text(
                    l.ai_mode_choose_title,
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: c.onSurface,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    l.ai_mode_choose_subtitle,
                    style: t.bodyMedium?.copyWith(
                      color: c.onSurfaceVariant.withAlpha(160),
                      height: 1.35,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Comparison Table Card
                  const AiModeComparisonCard(),

                  const SizedBox(height: 32),

                  // Download Local AI Model Button
                  EmbossedButton(
                    l.ai_button_start_download,
                    onPressed: () {
                      context.push(AppRoutes.loginAiDownload);
                    },
                  ),

                  const SizedBox(height: 12),

                  // Continue with Online Model link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<AiOnboardingBloc>().add(
                          const ChooseOnlineAiEvent(),
                        );
                      },
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: const Color(0xFF4A89A6),
                      ),
                      child: Text(
                        l.ai_button_continue_online,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
