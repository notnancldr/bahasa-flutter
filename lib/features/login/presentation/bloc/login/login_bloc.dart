import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/features/login/domain/enums/login_step_enum.dart';
import 'package:bahasa/features/login/domain/usecases/login_usecases.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LocaleCubit localeCubit;
  final ValidateLoginInputUseCase _validateLoginInputUseCase;
  final SaveLoginProfileUseCase _saveLoginProfileUseCase;

  LoginBloc({
    required this.localeCubit,
    ValidateLoginInputUseCase? validateLoginInputUseCase,
    SaveLoginProfileUseCase? saveLoginProfileUseCase,
  }) : _validateLoginInputUseCase =
           validateLoginInputUseCase ?? const ValidateLoginInputUseCase(),
       _saveLoginProfileUseCase =
           saveLoginProfileUseCase ?? const SaveLoginProfileUseCase(),
       super(DefaultLoginState()) {
    on<InputUsername>(_handleUsernameInput);
    on<SelectDefaultLanguage>(_handleDefaultLanguage);
    on<SaveProfile>(_handleSaveProfile);
    on<PreviousStep>(_handlePreviousStep);
  }

  bool _validateUsername(
    String? username, {
    int minLength = 3,
    int maxLength = 20,
  }) {
    return _validateLoginInputUseCase.validateUsername(
      username,
      minLength: minLength,
      maxLength: maxLength,
    );
  }

  bool _validateLanguage(String? language) {
    return _validateLoginInputUseCase.validateLanguage(language);
  }

  Future<void> _handleUsernameInput(
    InputUsername event,
    Emitter<LoginState> emit,
  ) async {
    final isValid = _validateUsername(event.username);
    final currentState = state;

    emit(
      currentState is InputState
          ? currentState.copyWith(
              step: LoginStep.username,
              username: event.username,
              isUsernameValid: isValid,
            )
          : DefaultLoginState(),
    );
  }

  Future<void> _handleDefaultLanguage(
    SelectDefaultLanguage event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    final isValid = _validateLanguage(event.language);

    String? language =
        event.language ??
        (currentState is InputState ? currentState.language : null);

    emit(
      currentState is InputState
          ? currentState.copyWith(
              step: LoginStep.language,
              language: language,
              isLanguageValid: isValid,
            )
          : DefaultLoginState(),
    );

    if (language == null) return;

    await _changeLanguage(language);
  }

  Future<void> _handleSaveProfile(
    SaveProfile event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state;
    if (currentState is! InputState) return;

    await _saveLoginProfileUseCase(
      username: currentState.username,
      language: currentState.language,
      isUsernameValid: currentState.isUsernameValid,
      isLanguageValid: currentState.isLanguageValid,
    );

    emit(ProfileSavedState());
  }

  void _handlePreviousStep(LoginEvent event, Emitter<LoginState> emit) {
    final currentState = state;
    if (currentState is! InputState) return;

    emit(switch (currentState) {
      InputState(step: LoginStep.language) => currentState.copyWith(
        step: LoginStep.username,
      ),
      InputState(step: LoginStep.username) => currentState,
    });
  }

  /// Persists the chosen language and applies it as the active app locale.
  Future<void> _changeLanguage(String language) async {
    await localeCubit.changeLanguage(
      language,
    ); // this already saves to SharedPreferences internally
  }

  // @override
  // Future<void> close() async {
  //   await _subscription?.cancel();
  //   await _importServer.dispose();
  //   return super.close();
  // }
}
