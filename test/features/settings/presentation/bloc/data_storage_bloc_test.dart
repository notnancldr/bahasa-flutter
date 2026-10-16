import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/domain/entities/data_transfer_result.dart';
import 'package:bahasa/features/settings/domain/repositories/data_storage_repository.dart';
import 'package:bahasa/features/settings/domain/usecases/delete_app_data_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/transfer_data_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockDataStorageRepository implements DataStorageRepository {
  bool shouldFail = false;
  bool isDeleted = false;

  @override
  Future<DataTransferResult> transferData({
    required String receiverCode,
  }) async {
    return const DataTransferResult(isSuccess: true, message: 'Success');
  }

  @override
  Future<void> deleteAppData({required String verificationUsername}) async {
    if (shouldFail) {
      throw const UsernameMismatchFailure(
        'The entered username does not match your current username.',
      );
    }
    isDeleted = true;
  }
}

void main() {
  late _MockDataStorageRepository repository;
  late TransferDataUseCase transferUseCase;
  late DeleteAppDataUseCase deleteUseCase;
  late DataStorageBloc bloc;

  setUp(() {
    repository = _MockDataStorageRepository();
    transferUseCase = TransferDataUseCase(repository);
    deleteUseCase = DeleteAppDataUseCase(repository);
    bloc = DataStorageBloc(
      transferDataUseCase: transferUseCase,
      deleteAppDataUseCase: deleteUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('DataStorageBloc Delete Data', () {
    test('initial state is DataStorageInitial', () {
      expect(bloc.state, equals(const DataStorageInitial()));
    });

    test('VerifyAndExecuteDeleteDataEvent emits [DeletingDataInProgress, DeleteDataSuccess] on success', () async {
      final expected = [
        isA<DeletingDataInProgress>(),
        isA<DeleteDataSuccess>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const VerifyAndExecuteDeleteDataEvent('validUser'));
    });

    test('VerifyAndExecuteDeleteDataEvent emits [DeletingDataInProgress, DeleteDataFailureState] on error', () async {
      repository.shouldFail = true;

      final expected = [
        isA<DeletingDataInProgress>(),
        isA<DeleteDataFailureState>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const VerifyAndExecuteDeleteDataEvent('wrongUser'));
    });

    test('CancelDeleteDataEvent emits DataStorageInitial', () async {
      expectLater(bloc.stream, emits(const DataStorageInitial()));
      bloc.add(const CancelDeleteDataEvent());
    });
  });
}
