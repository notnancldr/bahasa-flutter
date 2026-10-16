import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_card_log.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_item.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_period.dart';
import 'package:bahasa/features/decks/deck_history/domain/entities/deck_history_summary.dart';
import 'package:bahasa/features/decks/deck_history/domain/repositories/deck_history_repository.dart';
import 'package:bahasa/features/decks/deck_history/domain/usecases/get_deck_history_usecase.dart';
import 'package:bahasa/features/decks/deck_history/domain/usecases/get_session_card_logs_usecase.dart';
import 'package:bahasa/features/decks/deck_history/presentation/bloc/deck_history_bloc.dart';
import 'package:bahasa/features/decks/deck_history/presentation/bloc/deck_history_state.dart';
import 'package:bahasa/features/decks/deck_history/presentation/pages/deck_history_page.dart';
import 'package:bahasa/features/decks/deck_history/presentation/widgets/deck_history_details_sheet.dart';
import 'package:bahasa/features/decks/deck_history/presentation/widgets/deck_history_item_card.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHistoryRepository implements DeckHistoryRepository {
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
  late _FakeHistoryRepository repository;
  late DeckHistoryBloc bloc;

  setUp(() {
    repository = _FakeHistoryRepository();
    bloc = DeckHistoryBloc(
      getDeckHistoryUseCase: GetDeckHistoryUseCase(repository),
      getSessionCardLogsUseCase: GetSessionCardLogsUseCase(repository),
      initialDeckId: 'deck_1',
    );
  });

  tearDown(() {
    bloc.close();
  });

  Widget buildApp(DeckHistoryBloc bloc) {
    return MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('id'),
      home: DeckHistoryPage(deckId: 'deck_1', bloc: bloc),
    );
  }

  testWidgets(
    'DeckHistoryPage renders title, period toggle, summary card, and items',
    (tester) async {
      final now = DateTime(2026, 10, 16, 16, 30);
      final items = [
        DeckHistoryItem(
          sessionId: 'ses_1',
          deckId: 'deck_1',
          deckName: 'kosakata bahasa jepang',
          gameType: 'quiz',
          startedAt: now.subtract(const Duration(minutes: 19)),
          completedAt: now,
          totalQuestions: 10,
          correctCount: 9,
          finalScore: 90.0,
          durationMs: 19 * 60000,
        ),
      ];
      final summary = const DeckHistorySummary(
        totalActivities: 1,
        totalDurationMs: 19 * 60000,
        averageAccuracy: 90,
      );
      repository.logs = [
        DeckHistoryCardLog(
          logId: 'log_1',
          cardId: 'card_1',
          defaultLanguage: 'Konnichiwa',
          translation: 'Halo',
          isCorrect: true,
          timeSpentMs: 4000,
          timestamp: now,
        ),
        DeckHistoryCardLog(
          logId: 'log_2',
          cardId: 'card_2',
          defaultLanguage: 'Arigatou',
          translation: 'Terima kasih',
          isCorrect: false,
          timeSpentMs: 5000,
          timestamp: now,
        ),
      ];

      final bloc = DeckHistoryBloc(
        getDeckHistoryUseCase: GetDeckHistoryUseCase(repository),
        getSessionCardLogsUseCase: GetSessionCardLogsUseCase(repository),
        initialDeckId: 'deck_1',
        initialState: DeckHistoryState(
          status: DeckHistoryStatus.loaded,
          deckId: 'deck_1',
          period: DeckHistoryPeriod.week,
          summary: summary,
          items: items,
        ),
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(buildApp(bloc));
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('Riwayat Aktifitas'), findsOneWidget);

      // Verify Period Toggle options
      expect(find.text('Minggu ini'), findsWidgets);
      expect(find.text('Bulan ini'), findsOneWidget);
      expect(find.text('Tahun ini'), findsOneWidget);

      // Verify Summary Card
      expect(find.text('Ringkasan Minggu ini'), findsOneWidget);
      expect(find.text('1 sesi'), findsOneWidget);
      expect(find.text('19m'), findsOneWidget);
      expect(find.text('90%'), findsOneWidget);

      // Verify Session Item
      expect(find.byType(DeckHistoryItemCard), findsOneWidget);
      expect(find.text('Kuis kata'), findsOneWidget);
      expect(find.text('kosakata bahasa jepang'), findsOneWidget);
      expect(find.text('9 / 10 Benar'), findsOneWidget);
      expect(find.text('19 Menit'), findsOneWidget);

      // Tap Session Item to open Details Sheet
      await tester.tap(find.byType(DeckHistoryItemCard));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify Details Sheet
      expect(find.byType(DeckHistoryDetailsSheet), findsOneWidget);
      expect(find.text('9 / 10 Benar'), findsWidgets);
      expect(find.text('Jawaban Tepat'), findsOneWidget);
      expect(find.text('Durasi Sesi'), findsOneWidget);
      expect(find.text('Kartu yang di pelajari'), findsOneWidget);
      expect(find.text('Konnichiwa'), findsOneWidget);
      expect(find.text('Hafal'), findsOneWidget);
      expect(find.text('Arigatou'), findsOneWidget);
      expect(find.text('Perlu diulang'), findsOneWidget);

      // Tap "Tutup rincian" button
      expect(find.text('Tutup rincian'), findsOneWidget);
      await tester.tap(find.text('Tutup rincian'));
      await tester.pumpAndSettle();

      // Modal dismissed
      expect(find.byType(DeckHistoryDetailsSheet), findsNothing);
    },
  );

  testWidgets('DeckHistoryPage shows empty view when there are no activities', (
    tester,
  ) async {
    final bloc = DeckHistoryBloc(
      getDeckHistoryUseCase: GetDeckHistoryUseCase(repository),
      getSessionCardLogsUseCase: GetSessionCardLogsUseCase(repository),
      initialDeckId: 'deck_1',
      initialState: const DeckHistoryState(
        status: DeckHistoryStatus.loaded,
        deckId: 'deck_1',
        period: DeckHistoryPeriod.week,
        summary: DeckHistorySummary.empty,
        items: [],
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(buildApp(bloc));
    await tester.pumpAndSettle();

    expect(find.text('Belum Ada Aktivitas'), findsOneWidget);
    expect(find.byType(DeckHistoryItemCard), findsNothing);
  });
}
