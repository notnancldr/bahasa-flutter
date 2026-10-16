import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_card_log.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_item.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_period.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_summary.dart';
import 'package:bahasa/features/decks/deck_history/domain/repositories/deck_history_repository.dart';
import 'package:bahasa/features/decks/deck_history/domain/usecases/get_deck_history_usecase.dart';
import 'package:bahasa/features/decks/deck_history/domain/usecases/get_session_card_logs_usecase.dart';
import 'package:bahasa/features/decks/deck_history/presentation/bloc/deck_history_bloc.dart';
import 'package:bahasa/features/decks/deck_history/presentation/bloc/deck_history_event.dart';
import 'package:bahasa/features/decks/deck_history/presentation/bloc/deck_history_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDeckHistoryRepository implements DeckHistoryRepository {
  List<DeckHistoryItem> items = [];
  DeckHistorySummary summary = DeckHistorySummary.empty;
  List<DeckHistoryCardLog> logs = [];

  @override
  Future<List<DeckHistoryItem>> getHistoryItems({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) async {
    return items;
  }

  @override
  Future<DeckHistorySummary> getHistorySummary({
    String? deckId,
    required DeckHistoryPeriod period,
    DateTime? referenceDate,
  }) async {
    return summary;
  }

  @override
  Future<List<DeckHistoryCardLog>> getSessionCardLogs({
    required String deckId,
    required String sessionId,
  }) async {
    return logs;
  }
}

void main() {
  late _FakeDeckHistoryRepository repository;
  late GetDeckHistoryUseCase getDeckHistoryUseCase;
  late GetSessionCardLogsUseCase getSessionCardLogsUseCase;
  late DeckHistoryBloc bloc;

  setUp(() {
    repository = _FakeDeckHistoryRepository();
    getDeckHistoryUseCase = GetDeckHistoryUseCase(repository);
    getSessionCardLogsUseCase = GetSessionCardLogsUseCase(repository);
    bloc = DeckHistoryBloc(
      getDeckHistoryUseCase: getDeckHistoryUseCase,
      getSessionCardLogsUseCase: getSessionCardLogsUseCase,
      initialDeckId: 'deck_1',
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('LoadDeckHistory updates state with items and summary', () async {
    final now = DateTime.now();
    repository.items = [
      DeckHistoryItem(
        sessionId: 'ses_1',
        deckId: 'deck_1',
        deckName: 'Japanese Deck',
        gameType: 'quiz',
        startedAt: now.subtract(const Duration(minutes: 10)),
        completedAt: now,
        totalQuestions: 10,
        correctCount: 9,
        finalScore: 90.0,
        durationMs: 60000,
      ),
    ];
    repository.summary = const DeckHistorySummary(
      totalActivities: 1,
      totalDurationMs: 60000,
      averageAccuracy: 90,
    );

    bloc.add(const LoadDeckHistory());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<DeckHistoryState>(
          (s) => s.status == DeckHistoryStatus.loading,
        ),
        predicate<DeckHistoryState>((s) {
          return s.status == DeckHistoryStatus.loaded &&
              s.items.length == 1 &&
              s.summary.totalActivities == 1 &&
              s.summary.averageAccuracy == 90;
        }),
      ]),
    );
  });

  test('ChangeHistoryPeriod switches period and reloads', () async {
    bloc.add(const ChangeHistoryPeriod(DeckHistoryPeriod.month));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<DeckHistoryState>(
          (s) =>
              s.status == DeckHistoryStatus.loading &&
              s.period == DeckHistoryPeriod.month,
        ),
        predicate<DeckHistoryState>(
          (s) =>
              s.status == DeckHistoryStatus.loaded &&
              s.period == DeckHistoryPeriod.month,
        ),
      ]),
    );
  });

  test('LoadSessionLogs loads card logs for inspected session', () async {
    repository.logs = [
      DeckHistoryCardLog(
        logId: 'log_1',
        cardId: 'card_1',
        defaultLanguage: 'Neko',
        translation: 'Kucing',
        isCorrect: true,
        timeSpentMs: 4000,
        timestamp: DateTime.now(),
      ),
    ];

    bloc.add(const LoadSessionLogs(deckId: 'deck_1', sessionId: 'ses_1'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<DeckHistoryState>(
          (s) => s.isLoadingLogs && s.selectedSessionId == 'ses_1',
        ),
        predicate<DeckHistoryState>(
          (s) =>
              !s.isLoadingLogs &&
              s.sessionLogs.length == 1 &&
              s.sessionLogs.first.defaultLanguage == 'Neko',
        ),
      ]),
    );
  });
}
