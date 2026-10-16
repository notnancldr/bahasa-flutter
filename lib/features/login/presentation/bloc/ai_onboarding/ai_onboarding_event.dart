import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';

abstract class AiOnboardingEvent {
  const AiOnboardingEvent();
}

/// User selected online AI model.
class ChooseOnlineAiEvent extends AiOnboardingEvent {
  const ChooseOnlineAiEvent();
}

/// User triggered local AI download.
class StartLocalAiDownloadEvent extends AiOnboardingEvent {
  final String? customDownloadUrl;
  const StartLocalAiDownloadEvent({this.customDownloadUrl});
}

/// Download progress tick received from ModelDownloadService.
class ModelDownloadProgressUpdatedEvent extends AiOnboardingEvent {
  final ModelDownloadProgress progress;
  const ModelDownloadProgressUpdatedEvent(this.progress);
}

/// User chose to continue in background.
class ContinueInBackgroundEvent extends AiOnboardingEvent {
  const ContinueInBackgroundEvent();
}

/// User completed download and tapped "Selesai".
class CompleteOnboardingEvent extends AiOnboardingEvent {
  const CompleteOnboardingEvent();
}

/// Retry download after an error.
class RetryLocalAiDownloadEvent extends AiOnboardingEvent {
  const RetryLocalAiDownloadEvent();
}
