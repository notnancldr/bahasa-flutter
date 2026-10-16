import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/usecases/delete_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/pick_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_default_language_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_username_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateUsernameUseCase updateUsernameUseCase;
  final UpdateProfilePhotoUseCase updateProfilePhotoUseCase;
  final PickProfilePhotoUseCase pickProfilePhotoUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final SetDefaultLanguageUsecase setDefaultLanguageUsecase;

  UserProfile? _currentProfile;

  AccountBloc({
    required this.getProfileUseCase,
    required this.updateUsernameUseCase,
    required this.updateProfilePhotoUseCase,
    required this.pickProfilePhotoUseCase,
    required this.deleteProfileUseCase,
    required this.setDefaultLanguageUsecase,
  }) : super(const AccountInitial()) {
    on<LoadAccountEvent>(_onLoadAccount);
    on<PickAndChangePhotoEvent>(_onPickAndChangePhoto);
    on<ChangeProfilePhotoEvent>(_onChangeProfilePhoto);
    on<ChangeUsernameEvent>(_onChangeUsername);
    on<ChangeDefaultLanguageEvent>(_onChangeDefaultLanguage);
    on<RequestDeleteProfileConfirmationEvent>(_onRequestDeleteConfirmation);
    on<ConfirmDeleteProfileEvent>(_onConfirmDeleteProfile);
    on<CancelAccountActionEvent>(_onCancelAccountAction);
  }

  Future<void> _onLoadAccount(
    LoadAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountLoading());
    try {
      final profile = await getProfileUseCase();
      _currentProfile = profile;
      emit(AccountLoaded(profile));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onPickAndChangePhoto(
    PickAndChangePhotoEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final pickedPath = await pickProfilePhotoUseCase();
      if (pickedPath != null) {
        final updated = await updateProfilePhotoUseCase(pickedPath);
        _currentProfile = updated;
        emit(AccountPhotoUpdated(updated));
      }
    } catch (e) {
      emit(AccountError(e.toString(), previousProfile: _currentProfile));
    }
  }

  Future<void> _onChangeProfilePhoto(
    ChangeProfilePhotoEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final updated = await updateProfilePhotoUseCase(event.photoPath);
      _currentProfile = updated;
      emit(AccountPhotoUpdated(updated));
    } catch (e) {
      emit(AccountError(e.toString(), previousProfile: _currentProfile));
    }
  }

  Future<void> _onChangeUsername(
    ChangeUsernameEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final updated = await updateUsernameUseCase(event.newUsername);
      _currentProfile = updated;
      emit(AccountUsernameUpdated(updated));
    } catch (e) {
      emit(AccountError(e.toString(), previousProfile: _currentProfile));
    }
  }

  Future<void> _onChangeDefaultLanguage(
    ChangeDefaultLanguageEvent event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final updated = await setDefaultLanguageUsecase(event.newLanguage);
      _currentProfile = updated;
      emit(AccountLanguageUpdated(updated));
    } catch (e) {
      emit(AccountError(e.toString(), previousProfile: _currentProfile));
    }
  }

  void _onRequestDeleteConfirmation(
    RequestDeleteProfileConfirmationEvent event,
    Emitter<AccountState> emit,
  ) {
    if (_currentProfile != null) {
      emit(AccountConfirmDeletePrompt(_currentProfile!));
    }
  }

  Future<void> _onConfirmDeleteProfile(
    ConfirmDeleteProfileEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountDeleting());
    try {
      await deleteProfileUseCase();
      _currentProfile = null;
      emit(const AccountDeletedSuccess());
    } catch (e) {
      emit(AccountError(e.toString(), previousProfile: _currentProfile));
    }
  }

  void _onCancelAccountAction(
    CancelAccountActionEvent event,
    Emitter<AccountState> emit,
  ) {
    // ACC-04, ACC-07: If cancelled, revert to loaded profile without changes (Do Nothing)
    if (_currentProfile != null) {
      emit(AccountLoaded(_currentProfile!));
    } else {
      add(const LoadAccountEvent());
    }
  }
}
