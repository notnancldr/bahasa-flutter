import 'dart:async';

import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ai_onboarding_event.dart';
import 'ai_onboarding_state.dart';

/// BLoC orchestrating the AI selection and model download steps of onboarding.
class AiOnboardingBloc extends Bloc<AiOnboardingEvent, AiOnboardingState> {
  final SettingsRepository _settingsRepository;
  final ModelDownloadService _downloadService;
  StreamSubscription<ModelDownloadProgress>? _progressSubscription;

  AiOnboardingBloc({
    required this._settingsRepository,
    ModelDownloadService? downloadService,
  }) : _downloadService = downloadService ?? ModelDownloadService(),
       super(const AiModeChoosingState()) {
    on<ChooseOnlineAiEvent>(_onChooseOnlineAi);
    on<StartLocalAiDownloadEvent>(_onStartLocalAiDownload);
    on<ModelDownloadProgressUpdatedEvent>(_onProgressUpdated);
    on<ContinueInBackgroundEvent>(_onContinueInBackground);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
    on<RetryLocalAiDownloadEvent>(_onRetryLocalAiDownload);
  }

  Future<void> _onChooseOnlineAi(
    ChooseOnlineAiEvent event,
    Emitter<AiOnboardingState> emit,
  ) async {
    await _settingsRepository.setAiModelPreference(AiModelType.online);
    await _settingsRepository.setOnboardingCompleted(true);
    emit(const AiOnboardingFinishedState(AiModelType.online));
  }

  Future<void> _onStartLocalAiDownload(
    StartLocalAiDownloadEvent event,
    Emitter<AiOnboardingState> emit,
  ) async {
    await _settingsRepository.setAiModelPreference(AiModelType.local);

    emit(AiModelDownloadingState(_downloadService.currentProgress));

    await _progressSubscription?.cancel();
    _progressSubscription = _downloadService.progressStream.listen((progress) {
      add(ModelDownloadProgressUpdatedEvent(progress));
    });

    _downloadService.startDownload(downloadUrl: event.customDownloadUrl);
  }

  void _onProgressUpdated(
    ModelDownloadProgressUpdatedEvent event,
    Emitter<AiOnboardingState> emit,
  ) {
    switch (event.progress.status) {
      case ModelDownloadStatus.idle:
      case ModelDownloadStatus.downloading:
        emit(AiModelDownloadingState(event.progress));
        break;
      case ModelDownloadStatus.completed:
        emit(const AiModelDownloadCompleteState());
        break;
      case ModelDownloadStatus.failed:
        emit(
          AiModelDownloadErrorState(
            event.progress.errorMessage ?? 'Download error occurred.',
          ),
        );
        break;
    }
  }

  Future<void> _onContinueInBackground(
    ContinueInBackgroundEvent event,
    Emitter<AiOnboardingState> emit,
  ) async {
    await _settingsRepository.setOnboardingCompleted(true);
    emit(const AiOnboardingFinishedState(AiModelType.local));
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<AiOnboardingState> emit,
  ) async {
    await _settingsRepository.setOnboardingCompleted(true);
    emit(const AiOnboardingFinishedState(AiModelType.local));
  }

  void _onRetryLocalAiDownload(
    RetryLocalAiDownloadEvent event,
    Emitter<AiOnboardingState> emit,
  ) {
    add(const StartLocalAiDownloadEvent());
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }
}
