import 'dart:async';

import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_event.dart';
import 'package:bahasa/features/login/presentation/bloc/ai_onboarding/ai_onboarding_state.dart';
import 'package:bahasa/features/settings/domain/entities/app_theme_mode.dart';
import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSettingsRepository implements SettingsRepository {
  AiModelType aiModelPreference = AiModelType.online;
  bool onboardingCompleted = false;
  String? geminiApiKey;

  @override
  Future<AiModelType> getAiModelPreference() async => aiModelPreference;

  @override
  Future<void> setAiModelPreference(AiModelType mode) async {
    aiModelPreference = mode;
  }

  @override
  Future<bool> isOnboardingCompleted() async => onboardingCompleted;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    onboardingCompleted = completed;
  }

  @override
  Future<String?> getGeminiApiKey() async => geminiApiKey;

  @override
  Future<void> setGeminiApiKey(String apiKey) async {
    geminiApiKey = apiKey;
  }

  @override
  Future<bool> canGenerateOnlineDeckToday() async => true;

  @override
  Future<void> recordOnlineDeckGeneration() async {}

  @override
  Future<AppThemeMode> getThemeMode() async => AppThemeMode.system;

  @override
  Future<void> setThemeMode(AppThemeMode themeMode) async {}

  @override
  Future<NotificationSettings> getNotificationSettings() async =>
      const NotificationSettings(isEnabled: false);

  @override
  Future<void> setNotificationSettings(NotificationSettings settings) async {}
}

class _FakeModelDownloadService extends ModelDownloadService {
  _FakeModelDownloadService() : super.create();

  final _testController = StreamController<ModelDownloadProgress>.broadcast();

  @override
  Stream<ModelDownloadProgress> get progressStream => _testController.stream;

  ModelDownloadProgress _fakeProgress = const ModelDownloadProgress.idle();

  @override
  ModelDownloadProgress get currentProgress => _fakeProgress;

  bool wasStartDownloadCalled = false;

  void emitProgress(ModelDownloadProgress progress) {
    _fakeProgress = progress;
    _testController.add(progress);
  }

  @override
  Future<void> startDownload({String? downloadUrl}) async {
    wasStartDownloadCalled = true;
  }

  @override
  void cancelDownload() {}
}

void main() {
  group('AiOnboardingBloc', () {
    late _FakeSettingsRepository settingsRepo;
    late _FakeModelDownloadService downloadService;

    setUp(() {
      settingsRepo = _FakeSettingsRepository();
      downloadService = _FakeModelDownloadService();
    });

    test('initial state is AiModeChoosingState', () {
      final bloc = AiOnboardingBloc(
        settingsRepository: settingsRepo,
        downloadService: downloadService,
      );
      expect(bloc.state, isA<AiModeChoosingState>());
      bloc.close();
    });

    test('ChooseOnlineAiEvent saves preference, completes onboarding, and emits finished', () async {
      final bloc = AiOnboardingBloc(
        settingsRepository: settingsRepo,
        downloadService: downloadService,
      );

      bloc.add(const ChooseOnlineAiEvent());
      await Future<void>.delayed(Duration.zero);

      expect(settingsRepo.aiModelPreference, equals(AiModelType.online));
      expect(settingsRepo.onboardingCompleted, isTrue);
      expect(
        bloc.state,
        equals(const AiOnboardingFinishedState(AiModelType.online)),
      );

      await bloc.close();
    });

    test(
      'StartLocalAiDownloadEvent sets local preference and calls download',
      () async {
        final bloc = AiOnboardingBloc(
          settingsRepository: settingsRepo,
          downloadService: downloadService,
        );

        bloc.add(const StartLocalAiDownloadEvent());
        await Future<void>.delayed(Duration.zero);

        expect(settingsRepo.aiModelPreference, equals(AiModelType.local));
        expect(downloadService.wasStartDownloadCalled, isTrue);
        expect(bloc.state, isA<AiModelDownloadingState>());

        await bloc.close();
      },
    );

    test(
      'progress updates emit downloading, complete, and error states',
      () async {
        final bloc = AiOnboardingBloc(
          settingsRepository: settingsRepo,
          downloadService: downloadService,
        );

        bloc.add(const StartLocalAiDownloadEvent());
        await Future<void>.delayed(Duration.zero);

        // Downloading state
        downloadService.emitProgress(
          const ModelDownloadProgress(
            downloadedBytes: 500,
            totalBytes: 1000,
            status: ModelDownloadStatus.downloading,
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<AiModelDownloadingState>());
        expect(
          (bloc.state as AiModelDownloadingState).progress.downloadedBytes,
          equals(500),
        );

        // Complete state
        downloadService.emitProgress(
          const ModelDownloadProgress(
            downloadedBytes: 1000,
            totalBytes: 1000,
            status: ModelDownloadStatus.completed,
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<AiModelDownloadCompleteState>());

        // Failed state
        downloadService.emitProgress(
          const ModelDownloadProgress(
            downloadedBytes: 500,
            totalBytes: 1000,
            status: ModelDownloadStatus.failed,
            errorMessage: 'Disk full',
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<AiModelDownloadErrorState>());
        expect(
          (bloc.state as AiModelDownloadErrorState).errorMessage,
          equals('Disk full'),
        );

        await bloc.close();
      },
    );

    test(
      'ContinueInBackgroundEvent marks onboarding complete and emits finished',
      () async {
        final bloc = AiOnboardingBloc(
          settingsRepository: settingsRepo,
          downloadService: downloadService,
        );

        bloc.add(const ContinueInBackgroundEvent());
        await Future<void>.delayed(Duration.zero);

        expect(settingsRepo.onboardingCompleted, isTrue);
        expect(
          bloc.state,
          equals(const AiOnboardingFinishedState(AiModelType.local)),
        );

        await bloc.close();
      },
    );

    test(
      'CompleteOnboardingEvent marks onboarding complete and emits finished',
      () async {
        final bloc = AiOnboardingBloc(
          settingsRepository: settingsRepo,
          downloadService: downloadService,
        );

        bloc.add(const CompleteOnboardingEvent());
        await Future<void>.delayed(Duration.zero);

        expect(settingsRepo.onboardingCompleted, isTrue);
        expect(
          bloc.state,
          equals(const AiOnboardingFinishedState(AiModelType.local)),
        );

        await bloc.close();
      },
    );
  });
}
