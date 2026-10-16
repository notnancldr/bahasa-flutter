import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/login/login_dependencies.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_event.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_state.dart';
import 'package:bahasa/features/login/presentation/widgets/ai_mode/ai_model_download_complete_view.dart';
import 'package:bahasa/features/login/presentation/widgets/ai_mode/ai_model_download_progress_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Page displaying download progress for local AI model and completion state.
class AiModelDownloadPage extends StatelessWidget {
  const AiModelDownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoginDependencies.createAiOnboardingBloc()
            ..add(const StartLocalAiDownloadEvent()),
      child: const _AiModelDownloadView(),
    );
  }
}

class _AiModelDownloadView extends StatelessWidget {
  const _AiModelDownloadView();

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
            child: switch (state) {
              AiModelDownloadingState(:final progress) =>
                AiModelDownloadProgressView(
                  progress: progress,
                  onContinueInBackground: () {
                    context.read<AiOnboardingBloc>().add(
                      const ContinueInBackgroundEvent(),
                    );
                  },
                ),
              AiModelDownloadCompleteState() => AiModelDownloadCompleteView(
                onDone: () {
                  context.read<AiOnboardingBloc>().add(
                    const CompleteOnboardingEvent(),
                  );
                },
              ),
              AiModelDownloadErrorState(:final errorMessage) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: c.error),
                    const SizedBox(height: 16),
                    Text(
                      l.ai_download_error_title,
                      style: t.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    EmbossedButton(
                      l.ai_download_retry,
                      onPressed: () {
                        context.read<AiOnboardingBloc>().add(
                          const RetryLocalAiDownloadEvent(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        );
      },
    );
  }
}
