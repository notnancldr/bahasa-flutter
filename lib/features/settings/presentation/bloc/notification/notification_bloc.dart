import 'package:bahasa/features/settings/domain/entities/notification_settings.dart';
import 'package:bahasa/features/settings/domain/usecases/get_notification_settings_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_notification_settings_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationSettingsUseCase _getNotificationSettingsUseCase;
  final SetNotificationSettingsUseCase _setNotificationSettingsUseCase;

  NotificationBloc({
    required this._getNotificationSettingsUseCase,
    required this._setNotificationSettingsUseCase,
  })  : super(const NotificationState()) {
    on<LoadNotificationSettingsEvent>(_onLoadSettings);
    on<ToggleNotificationEvent>(_onToggleNotification);
  }

  Future<void> _onLoadSettings(
    LoadNotificationSettingsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isApplied: false));
    try {
      final settings = await _getNotificationSettingsUseCase();
      emit(state.copyWith(
        isEnabled: settings.isEnabled,
        isLoading: false,
        isApplied: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleNotification(
    ToggleNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isApplied: false));
    try {
      await _setNotificationSettingsUseCase(
        NotificationSettings(isEnabled: event.isEnabled),
      );
      emit(state.copyWith(
        isEnabled: event.isEnabled,
        isLoading: false,
        isApplied: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}

