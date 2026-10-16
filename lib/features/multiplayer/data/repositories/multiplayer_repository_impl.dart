import 'dart:async';

import 'package:bahasa/core/utils/random_char.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../../domain/entities/multiplayer_player.dart';
import '../../domain/repositories/multiplayer_repository.dart';
import '../datasources/multiplayer_client.dart';
import '../datasources/multiplayer_local_data_source.dart';
import '../datasources/multiplayer_server.dart';

/// Implementation of [MultiplayerRepository] coordinating [MultiplayerServer],
/// [MultiplayerClient], and [MultiplayerLocalDataSource].
class MultiplayerRepositoryImpl implements MultiplayerRepository {
  final MultiplayerServer _server;
  final MultiplayerClient _client;
  final MultiplayerLocalDataSource _localDataSource;

  final _stateController = StreamController<MultiplayerGameState>.broadcast();
  MultiplayerGameState _state = const MultiplayerGameState();
  MultiplayerRole? _currentRole;
  Uri? _connectedHostUri;

  StreamSubscription<MultiplayerServerEvent>? _serverEventSub;
  StreamSubscription<MultiplayerGameState>? _clientSseSub;

  MultiplayerRepositoryImpl({
    MultiplayerServer? server,
    MultiplayerClient? client,
    MultiplayerLocalDataSource? localDataSource,
  }) : _server = server ?? MultiplayerServer(),
       _client = client ?? MultiplayerClient(),
       _localDataSource = localDataSource ?? MultiplayerLocalDataSourceImpl();

  @override
  Stream<MultiplayerGameState> get gameStateStream => _stateController.stream;

  @override
  MultiplayerGameState get currentState => _state;

  @override
  MultiplayerRole? get currentRole => _currentRole;

  void _emit(MultiplayerGameState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
    if (_currentRole == MultiplayerRole.host && _server.isRunning) {
      _server.broadcastState(newState);
    }
  }

  @override
  Future<String> startHosting({required String hostName}) async {
    await leaveRoom();
    _currentRole = MultiplayerRole.host;

    final hostPlayer = MultiplayerPlayer(
      id: 'host_${randomChar(8)}',
      name: hostName.trim().isNotEmpty ? hostName.trim() : 'Host',
      isHost: true,
      badgeText: 'P1',
    );

    final ip = await _server.start(hostPlayer: hostPlayer);

    _serverEventSub = _server.events.listen((event) {
      switch (event) {
        case MultiplayerClientJoined(:final player):
          _emit(
            _state.copyWith(
              phase: MultiplayerPhase.lobby,
              guesserPlayer: player,
            ),
          );
        case MultiplayerGuesserAnswerReceived(:final answer):
          _handleGuesserAnswerOnHost(answer);
        case MultiplayerClientLeft():
          _emit(
            _state.copyWith(
              phase: MultiplayerPhase.disconnected,
              errorMessage: 'Client disconnected',
            ),
          );
      }
    });

    _emit(
      MultiplayerGameState(
        phase: MultiplayerPhase.hosting,
        hostPlayer: hostPlayer,
      ),
    );

    return ip;
  }

  @override
  Future<void> joinRoom({
    required String hostAddress,
    required String guesserName,
  }) async {
    await leaveRoom();
    _currentRole = MultiplayerRole.guesser;

    final targetUri = _client.resolveHostUri(hostAddress);
    _connectedHostUri = targetUri;

    _emit(const MultiplayerGameState(phase: MultiplayerPhase.joining));

    final isAlive = await _client.checkHost(targetUri);
    if (!isAlive) {
      throw const FormatException('Host is not reachable at this address.');
    }

    final guesserPlayer = MultiplayerPlayer(
      id: 'guesser_${randomChar(8)}',
      name: guesserName.trim().isNotEmpty ? guesserName.trim() : 'Player 2',
      isHost: false,
      badgeText: 'P2',
    );

    final hostPlayer = await _client.join(targetUri, guesserPlayer);

    _clientSseSub = _client
        .connectEventStream(targetUri)
        .listen(
          (incomingState) {
            // Merge or replace state received from host
            _emit(incomingState);
          },
          onError: (e) {
            _emit(
              _state.copyWith(
                phase: MultiplayerPhase.disconnected,
                errorMessage: e.toString(),
              ),
            );
          },
          onDone: () {
            _emit(
              _state.copyWith(
                phase: MultiplayerPhase.disconnected,
                errorMessage: 'Host disconnected',
              ),
            );
          },
        );

    _emit(
      MultiplayerGameState(
        phase: MultiplayerPhase.lobby,
        hostPlayer: hostPlayer,
        guesserPlayer: guesserPlayer,
      ),
    );
  }

  @override
  Future<List<DeckItem>> getAvailableDecks() async {
    return _localDataSource.getAllDecks();
  }

  @override
  Future<void> selectDeck(String deckId) async {
    if (_currentRole != MultiplayerRole.host) return;

    final allDecks = await _localDataSource.getAllDecks();
    final selected = allDecks.where((d) => d.id == deckId).firstOrNull;
    final deckTitle = selected?.name ?? 'Quiz Deck';

    final questions = await _localDataSource.generateQuestionsForDeck(deckId);
    if (questions.isEmpty) {
      _emit(_state.copyWith(errorMessage: 'No cards available in this deck.'));
      return;
    }

    final nowMs = DateTime.now().millisecondsSinceEpoch;

    _emit(
      _state.copyWith(
        phase: MultiplayerPhase.hostAnswering,
        deckId: deckId,
        deckTitle: deckTitle,
        questions: questions,
        currentQuestionIndex: 0,
        totalScore: 0,
        outcomes: const [],
        lastScoreDelta: 0,
        startedAtMs: nowMs,
        hostSelectedOption: null,
        guesserSelectedOption: null,
      ),
    );
  }

  @override
  Future<void> submitHostAnswer(String selectedOption) async {
    if (_currentRole != MultiplayerRole.host) return;
    if (_state.phase != MultiplayerPhase.hostAnswering) return;

    final question = _state.currentQuestion;
    if (question == null) return;

    final isCorrect =
        selectedOption.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    if (isCorrect) {
      // Host correct -> continue to guesser!
      _emit(
        _state.copyWith(
          phase: MultiplayerPhase.guesserTurn,
          hostSelectedOption: selectedOption,
        ),
      );
    } else {
      // Host wrong -> skip -> Score +0 (no change).
      // Only show correct answer feedback to host while guesser stays on waiting screen.
      final updatedOutcomes = List<bool?>.from(_state.outcomes)..add(null);
      _emit(
        _state.copyWith(
          phase: MultiplayerPhase.hostWrongFeedback,
          hostSelectedOption: selectedOption,
          outcomes: updatedOutcomes,
          lastScoreDelta: 0,
        ),
      );
    }
  }

  void _handleGuesserAnswerOnHost(String answer) {
    if (_state.phase != MultiplayerPhase.guesserTurn) return;

    final question = _state.currentQuestion;
    if (question == null) return;

    final isCorrect =
        answer.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    final delta = isCorrect ? 1 : -1;
    final newScore = _state.totalScore + delta;
    final updatedOutcomes = List<bool?>.from(_state.outcomes)..add(isCorrect);

    _emit(
      _state.copyWith(
        phase: MultiplayerPhase.scoreFeedback,
        guesserSelectedOption: answer,
        totalScore: newScore,
        lastScoreDelta: delta,
        outcomes: updatedOutcomes,
      ),
    );
  }

  @override
  Future<void> submitGuesserAnswer(String selectedOption) async {
    if (_currentRole != MultiplayerRole.guesser) return;
    if (_connectedHostUri == null) return;

    await _client.sendAnswer(_connectedHostUri!, selectedOption);
  }

  @override
  Future<void> advanceToNextQuestion() async {
    if (_currentRole != MultiplayerRole.host) return;

    final nextIndex = _state.currentQuestionIndex + 1;
    if (nextIndex < _state.questions.length) {
      // Advance to next question
      _emit(
        _state.copyWith(
          phase: MultiplayerPhase.hostAnswering,
          currentQuestionIndex: nextIndex,
          hostSelectedOption: null,
          guesserSelectedOption: null,
          lastScoreDelta: 0,
        ),
      );
    } else {
      // Session complete!
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final duration = nowMs - _state.startedAtMs;
      final sessionId = 'ses_mp_${nowMs}_${randomChar(6)}';

      if (_state.deckId != null) {
        await _localDataSource.saveCompletedSession(
          deckId: _state.deckId!,
          sessionId: sessionId,
          startedAtMs: _state.startedAtMs,
          durationMs: duration,
          totalQuestions: _state.questions.length,
          correctCount: _state.correctCount,
          finalScore: _state.totalScore.toDouble(),
          outcomes: _state.outcomes,
        );
      }

      _emit(
        _state.copyWith(
          phase: MultiplayerPhase.completed,
          durationMs: duration,
        ),
      );
    }
  }

  @override
  Future<void> leaveRoom() async {
    await _serverEventSub?.cancel();
    _serverEventSub = null;
    await _clientSseSub?.cancel();
    _clientSseSub = null;

    if (_currentRole == MultiplayerRole.guesser && _connectedHostUri != null) {
      await _client.leave(_connectedHostUri!);
      _connectedHostUri = null;
    }

    if (_currentRole == MultiplayerRole.host) {
      await _server.stop();
    }

    _currentRole = null;
    _emit(const MultiplayerGameState(phase: MultiplayerPhase.initial));
  }

  @override
  Future<void> stopServer() async {
    await _server.stop();
  }
}
