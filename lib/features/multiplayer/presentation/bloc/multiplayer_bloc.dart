import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../../domain/repositories/multiplayer_repository.dart';
import 'multiplayer_event.dart';
import 'multiplayer_state.dart';

/// BLoC orchestrating the 2-player cooperative multiplayer quiz session.
class MultiplayerBloc extends Bloc<MultiplayerEvent, MultiplayerState> {
  final MultiplayerRepository _repository;
  StreamSubscription<MultiplayerGameState>? _stateSubscription;

  /// Creates a [MultiplayerBloc].
  MultiplayerBloc({required this._repository})
    : super(
        MultiplayerState(
          role: _repository.currentRole,
          game: _repository.currentState,
        ),
      ) {
    on<StartHostRoomEvent>(_onStartHost);
    on<JoinRoomEvent>(_onJoinRoom);
    on<LoadMultiplayerDecksEvent>(_onLoadDecks);
    on<FilterMultiplayerDecksEvent>(_onFilterDecks);
    on<SelectMultiplayerDeckEvent>(_onSelectDeck);
    on<SubmitHostAnswerEvent>(_onSubmitHostAnswer);
    on<SubmitGuesserAnswerEvent>(_onSubmitGuesserAnswer);
    on<ContinueToNextQuestionEvent>(_onContinueToNextQuestion);
    on<LeaveMultiplayerEvent>(_onLeaveMultiplayer);
    on<InternalGameStateUpdatedEvent>(_onGameStateUpdated);

    _stateSubscription = _repository.gameStateStream.listen((gameState) {
      add(InternalGameStateUpdatedEvent(gameState));
    });
  }

  Future<void> _onStartHost(
    StartHostRoomEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final ip = await _repository.startHosting(hostName: event.hostName);
      emit(
        state.copyWith(
          role: MultiplayerRole.host,
          hostIp: ip,
          isLoading: false,
          game: _repository.currentState,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onJoinRoom(
    JoinRoomEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _repository.joinRoom(
        hostAddress: event.hostAddress,
        guesserName: event.guesserName,
      );
      emit(
        state.copyWith(
          role: MultiplayerRole.guesser,
          isLoading: false,
          game: _repository.currentState,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadDecks(
    LoadMultiplayerDecksEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final decks = await _repository.getAvailableDecks();
      emit(state.copyWith(decks: decks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onFilterDecks(
    FilterMultiplayerDecksEvent event,
    Emitter<MultiplayerState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSelectDeck(
    SelectMultiplayerDeckEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.selectDeck(event.deckId);
      emit(state.copyWith(isLoading: false, game: _repository.currentState));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSubmitHostAnswer(
    SubmitHostAnswerEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    try {
      await _repository.submitHostAnswer(event.option);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSubmitGuesserAnswer(
    SubmitGuesserAnswerEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    try {
      await _repository.submitGuesserAnswer(event.option);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onContinueToNextQuestion(
    ContinueToNextQuestionEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    try {
      await _repository.advanceToNextQuestion();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLeaveMultiplayer(
    LeaveMultiplayerEvent event,
    Emitter<MultiplayerState> emit,
  ) async {
    await _repository.leaveRoom();
    emit(
      const MultiplayerState(
        game: MultiplayerGameState(phase: MultiplayerPhase.initial),
      ),
    );
  }

  void _onGameStateUpdated(
    InternalGameStateUpdatedEvent event,
    Emitter<MultiplayerState> emit,
  ) {
    emit(
      state.copyWith(
        game: event.gameState,
        role: _repository.currentRole ?? state.role,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _stateSubscription?.cancel();
    return super.close();
  }
}
