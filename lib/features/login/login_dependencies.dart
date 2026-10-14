import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/features/login/data/repositories/transfer_repository_impl.dart';
import 'package:bahasa/features/login/domain/repositories/transfer_repository.dart';
import 'package:bahasa/features/login/domain/usecases/cancel_transfer_usecase.dart';
import 'package:bahasa/features/login/domain/usecases/login_usecases.dart';
import 'package:bahasa/features/login/domain/usecases/start_transfer_server_usecase.dart';
import 'package:bahasa/features/login/domain/usecases/validate_transferred_file_usecase.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_bloc.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';

/// Lightweight dependency factory for the Login & Transfer feature.
class LoginDependencies {
  static TransferRepository createTransferRepository() =>
      TransferRepositoryImpl();

  static TransferBloc createTransferBloc({TransferRepository? repository}) {
    final repo = repository ?? createTransferRepository();
    return TransferBloc(
      repository: repo,
      startTransferServerUseCase: StartTransferServerUseCase(repo),
      cancelTransferUseCase: CancelTransferUseCase(repo),
      validateTransferredFileUseCase: ValidateTransferredFileUseCase(repo),
    );
  }

  static LoginBloc createLoginBloc({required LocaleCubit localeCubit}) {
    return LoginBloc(
      localeCubit: localeCubit,
      validateLoginInputUseCase: const ValidateLoginInputUseCase(),
      saveLoginProfileUseCase: SaveLoginProfileUseCase(
        SettingsDependencies.createProfileRepository(),
      ),
    );
  }
}
