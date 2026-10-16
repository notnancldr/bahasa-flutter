import 'dart:async';

import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_game_state.dart';
import 'package:bahasa/features/multiplayer/domain/repositories/multiplayer_repository.dart';
import 'package:bahasa/features/multiplayer/presentation/bloc/multiplayer_bloc.dart';
import 'package:bahasa/features/multiplayer/presentation/bloc/multiplayer_event.dart';
import 'package:bahasa/features/multiplayer/presentation/bloc/multiplayer_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeMultiplayerRepository implements MultiplayerRepository {
  MultiplayerGameState _state = const MultiplayerGameState();
  final _controller = StreamController<MultiplayerGameState>.broadcast();
  MultiplayerRole? _role;

  @override
  Stream<MultiplayerGameState> get gameStateStream => _controller.stream;

  @override
  MultiplayerGameState get currentState => _state;

  @override
  MultiplayerRole? get currentRole => _role;

  void emitState(MultiplayerGameState state) {
    _state = state;
    _controller.add(state);
  }

  @override
  Future<String> startHosting({required String hostName}) async {
    _role = MultiplayerRole.host;
    _state = const MultiplayerGameState(phase: MultiplayerPhase.hosting);
    return '192.168.1.50';
  }

  @override
  Future<void> joinRoom({
    required String hostAddress,
    required String guesserName,
  }) async {
    _role = MultiplayerRole.guesser;
    _state = const MultiplayerGameState(phase: MultiplayerPhase.lobby);
  }

  @override
  Future<List<DeckItem>> getAvailableDecks() async {
    return [
      const DeckItem(
        id: 'd1',
        name: 'Deck 1',
        language: 'en',
        difficulty: 'beginner',
        activeTime: 0,
        createdAt: 0,
        updatedAt: 0,
      ),
    ];
  }

  @override
  Future<void> selectDeck(String deckId) async {
    _state = const MultiplayerGameState(phase: MultiplayerPhase.hostAnswering);
  }

  @override
  Future<void> submitHostAnswer(String selectedOption) async {}

  @override
  Future<void> submitGuesserAnswer(String selectedOption) async {}

  @override
  Future<void> advanceToNextQuestion() async {}

  @override
  Future<void> leaveRoom() async {
    _role = null;
    _state = const MultiplayerGameState(phase: MultiplayerPhase.initial);
  }

  @override
  Future<void> stopServer() async {}
}

void main() {
  group('MultiplayerBloc', () {
    late FakeMultiplayerRepository repository;
    late MultiplayerBloc bloc;

    setUp(() {
      repository = FakeMultiplayerRepository();
      bloc = MultiplayerBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('Initial state is idle', () {
      expect(bloc.state.phase, MultiplayerPhase.initial);
      expect(bloc.state.isHost, isFalse);
    });

    test('StartHostRoomEvent emits hosting state with IP', () async {
      bloc.add(const StartHostRoomEvent(hostName: 'Santi'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<MultiplayerState>((s) => s.isLoading == true),
          predicate<MultiplayerState>(
            (s) => s.role == MultiplayerRole.host && s.hostIp == '192.168.1.50',
          ),
        ]),
      );
    });

    test('LoadMultiplayerDecksEvent populates decks list', () async {
      bloc.add(const LoadMultiplayerDecksEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<MultiplayerState>((s) => s.isLoading == true),
          predicate<MultiplayerState>(
            (s) => s.decks.length == 1 && s.decks.first.name == 'Deck 1',
          ),
        ]),
      );
    });
  });
}
