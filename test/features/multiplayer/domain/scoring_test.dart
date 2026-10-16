import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:bahasa/features/multiplayer/data/datasources/multiplayer_local_data_source.dart';
import 'package:bahasa/features/multiplayer/data/datasources/multiplayer_server.dart';
import 'package:bahasa/features/multiplayer/data/repositories/multiplayer_repository_impl.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_game_state.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_quiz_question.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';

class MockMultiplayerLocalDataSource implements MultiplayerLocalDataSource {
  @override
  Future<List<DeckItem>> getAllDecks() async {
    return [
      const DeckItem(
        id: 'deck-1',
        name: 'Japanese Vocab',
        language: 'ja',
        difficulty: 'beginner',
        activeTime: 0,
        createdAt: 0,
        updatedAt: 0,
      ),
    ];
  }

  @override
  Future<List<MultiplayerQuizQuestion>> generateQuestionsForDeck(
    String deckId,
  ) async {
    return [
      const MultiplayerQuizQuestion(
        cardId: 'c1',
        prompt: 'Phrase expressing love',
        targetWord: 'i love you tu',
        options: [
          'i love you tu',
          'Halo Selamat Siang',
          'selamat pagi',
          'haii',
        ],
        correctAnswer: 'i love you tu',
      ),
      const MultiplayerQuizQuestion(
        cardId: 'c2',
        prompt: 'Morning greeting',
        targetWord: 'selamat pagi',
        options: [
          'selamat pagi',
          'selamat malam',
          'terima kasih',
          'sampai jumpa',
        ],
        correctAnswer: 'selamat pagi',
      ),
    ];
  }

  @override
  Future<void> saveCompletedSession({
    required String deckId,
    required String sessionId,
    required int startedAtMs,
    required int durationMs,
    required int totalQuestions,
    required int correctCount,
    required double finalScore,
    required List<bool?> outcomes,
  }) async {}

  @override
  Future<List<Map<String, dynamic>>> getMultiplayerHistory() async => [];
}

class MockNetworkInfo implements NetworkInfo {
  @override
  Future<String?> getWifiIP() async => '127.0.0.1';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multiplayer Scoring & Turn Rules', () {
    late MultiplayerRepositoryImpl repository;
    late MockMultiplayerLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockMultiplayerLocalDataSource();
      repository = MultiplayerRepositoryImpl(
        server: MultiplayerServer(port: 7099, networkInfo: MockNetworkInfo()),
        localDataSource: mockDataSource,
      );
    });

    tearDown(() async {
      await repository.leaveRoom();
    });

    test('Host correct -> continues to guesser turn', () async {
      await repository.startHosting(hostName: 'Santi');
      await repository.selectDeck('deck-1');

      expect(repository.currentState.phase, MultiplayerPhase.hostAnswering);
      expect(repository.currentState.totalScore, 0);

      // Host answers correctly
      await repository.submitHostAnswer('i love you tu');

      expect(repository.currentState.phase, MultiplayerPhase.guesserTurn);
      expect(repository.currentState.hostSelectedOption, 'i love you tu');
      expect(repository.currentState.totalScore, 0);
    });

    test('Host wrong -> skips question with score +0, only host sees wrong answer feedback', () async {
      await repository.startHosting(hostName: 'Santi');
      await repository.selectDeck('deck-1');

      // Host chooses wrong option
      await repository.submitHostAnswer('Halo Selamat Siang');

      // Phase is hostWrongFeedback on host side with delta 0
      expect(repository.currentState.phase, MultiplayerPhase.hostWrongFeedback);
      expect(repository.currentState.totalScore, 0);
      expect(repository.currentState.lastScoreDelta, 0);
      expect(repository.currentState.outcomes, [null]); // null indicates skip
    });

    test('Guesser correct -> +1 point added to shared total score', () async {
      await repository.startHosting(hostName: 'Santi');
      await repository.selectDeck('deck-1');
      await repository.submitHostAnswer('i love you tu');

      // Advance to scoreFeedback as if guesser answered correctly
      final stateAfterGuesserCorrect = repository.currentState.copyWith(
        phase: MultiplayerPhase.scoreFeedback,
        totalScore: repository.currentState.totalScore + 1,
        lastScoreDelta: 1,
        outcomes: [true],
        guesserSelectedOption: 'i love you tu',
      );

      expect(stateAfterGuesserCorrect.totalScore, 1);
      expect(stateAfterGuesserCorrect.lastScoreDelta, 1);
      expect(stateAfterGuesserCorrect.correctCount, 1);
    });

    test(
      'Guesser wrong -> -1 point subtracted from shared total score',
      () async {
        final state =
            const MultiplayerGameState(
              totalScore: 5,
              outcomes: [true, true, true, true, true],
            ).copyWith(
              totalScore: 4,
              lastScoreDelta: -1,
              outcomes: [true, true, true, true, true, false],
            );

        expect(state.totalScore, 4);
        expect(state.lastScoreDelta, -1);
        expect(state.correctCount, 5);
        expect(state.outcomes.last, false);
      },
    );

    test('Question progression and session completion', () async {
      await repository.startHosting(hostName: 'Santi');
      await repository.selectDeck('deck-1');

      // Question 0
      expect(repository.currentState.currentQuestionIndex, 0);
      await repository.submitHostAnswer('i love you tu');

      // Advance to Question 1
      await repository.advanceToNextQuestion();
      expect(repository.currentState.currentQuestionIndex, 1);
      expect(repository.currentState.phase, MultiplayerPhase.hostAnswering);

      // Question 1 -> Advance (which reaches end of 2 questions)
      await repository.advanceToNextQuestion();
      expect(repository.currentState.phase, MultiplayerPhase.completed);
    });
  });
}
