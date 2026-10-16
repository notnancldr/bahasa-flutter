import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';

abstract class AiOnboardingState {
  const AiOnboardingState();
}

/// Initial screen where user selects between Online and Local AI mode.
class AiModeChoosingState extends AiOnboardingState {
  const AiModeChoosingState();
}

/// Local model is downloading with active progress.
class AiModelDownloadingState extends AiOnboardingState {
  final ModelDownloadProgress progress;
  const AiModelDownloadingState(this.progress);
}

/// Model download completed successfully.
class AiModelDownloadCompleteState extends AiOnboardingState {
  const AiModelDownloadCompleteState();
}

/// Model download encountered an error.
class AiModelDownloadErrorState extends AiOnboardingState {
  final String errorMessage;
  const AiModelDownloadErrorState(this.errorMessage);
}

/// Onboarding is fully finished, proceed to main dashboard.
class AiOnboardingFinishedState extends AiOnboardingState {
  final AiModelType chosenMode;
  const AiOnboardingFinishedState(this.chosenMode);
}
