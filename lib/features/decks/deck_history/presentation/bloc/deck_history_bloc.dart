import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_deck_history_usecase.dart';
import '../../domain/usecases/get_session_card_logs_usecase.dart';
import 'deck_history_event.dart';
import 'deck_history_state.dart';

/// BLoC orchestrating state transitions for the Deck History page.
class DeckHistoryBloc extends Bloc<DeckHistoryEvent, DeckHistoryState> {
  final GetDeckHistoryUseCase _getDeckHistoryUseCase;
  final GetSessionCardLogsUseCase _getSessionCardLogsUseCase;

  /// Creates a [DeckHistoryBloc].
  DeckHistoryBloc({
    required this._getDeckHistoryUseCase,
    required this._getSessionCardLogsUseCase,
    String? initialDeckId,
    DeckHistoryState? initialState,
  }) : super(initialState ?? DeckHistoryState(deckId: initialDeckId)) {
    on<LoadDeckHistory>(_onLoadDeckHistory);
    on<ChangeHistoryPeriod>(_onChangeHistoryPeriod);
    on<LoadSessionLogs>(_onLoadSessionLogs);
  }

  Future<void> _onLoadDeckHistory(
    LoadDeckHistory event,
    Emitter<DeckHistoryState> emit,
  ) async {
    final targetDeckId = event.deckId ?? state.deckId;
    final targetPeriod = event.period ?? state.period;

    emit(
      state.copyWith(
        status: DeckHistoryStatus.loading,
        deckId: targetDeckId,
        period: targetPeriod,
      ),
    );

    try {
      final result = await _getDeckHistoryUseCase(
        deckId: targetDeckId,
        period: targetPeriod,
      );

      emit(
        state.copyWith(
          status: DeckHistoryStatus.loaded,
          summary: result.summary,
          items: result.items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DeckHistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onChangeHistoryPeriod(
    ChangeHistoryPeriod event,
    Emitter<DeckHistoryState> emit,
  ) async {
    if (state.period == event.period &&
        state.status == DeckHistoryStatus.loaded) {
      return;
    }

    emit(
      state.copyWith(status: DeckHistoryStatus.loading, period: event.period),
    );

    try {
      final result = await _getDeckHistoryUseCase(
        deckId: state.deckId,
        period: event.period,
      );

      emit(
        state.copyWith(
          status: DeckHistoryStatus.loaded,
          summary: result.summary,
          items: result.items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DeckHistoryStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadSessionLogs(
    LoadSessionLogs event,
    Emitter<DeckHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedSessionId: event.sessionId,
        isLoadingLogs: true,
        sessionLogs: const [],
      ),
    );

    try {
      final logs = await _getSessionCardLogsUseCase(
        deckId: event.deckId,
        sessionId: event.sessionId,
      );

      emit(state.copyWith(isLoadingLogs: false, sessionLogs: logs));
    } catch (e) {
      emit(state.copyWith(isLoadingLogs: false, errorMessage: e.toString()));
    }
  }
}
