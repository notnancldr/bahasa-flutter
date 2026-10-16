import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_game_state.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_player.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_quiz_question.dart';
import 'package:bahasa/features/multiplayer/domain/repositories/multiplayer_repository.dart';
import 'package:bahasa/features/multiplayer/presentation/bloc/multiplayer_bloc.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_complete_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_game_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_lobby_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_main_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_room_page.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:async';

class _FakeAccountBloc extends Bloc<AccountEvent, AccountState>
    implements AccountBloc {
  _FakeAccountBloc()
    : super(
        const AccountLoaded(
          UserProfile(username: 'Santi', defaultLanguage: 'id'),
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestMultiplayerRepo implements MultiplayerRepository {
  MultiplayerGameState _state = const MultiplayerGameState();
  final _controller = StreamController<MultiplayerGameState>.broadcast();
  MultiplayerRole? _role;

  _TestMultiplayerRepo([
    this._state = const MultiplayerGameState(),
    this._role,
  ]);

  @override
  Stream<MultiplayerGameState> get gameStateStream => _controller.stream;
  @override
  MultiplayerGameState get currentState => _state;
  @override
  MultiplayerRole? get currentRole => _role;

  @override
  Future<String> startHosting({required String hostName}) async {
    _role = MultiplayerRole.host;
    _state = const MultiplayerGameState(phase: MultiplayerPhase.hosting);
    return '192.168.1.24';
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
  Future<List<DeckItem>> getAvailableDecks() async => [];
  @override
  Future<void> selectDeck(String deckId) async {}
  @override
  Future<void> submitHostAnswer(String selectedOption) async {}
  @override
  Future<void> submitGuesserAnswer(String selectedOption) async {}
  @override
  Future<void> advanceToNextQuestion() async {}
  @override
  Future<void> leaveRoom() async {}
  @override
  Future<void> stopServer() async {}
}

Widget _wrapWithApp({
  required Widget child,
  MultiplayerBloc? mpBloc,
  AccountBloc? accountBloc,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AccountBloc>(
        create: (_) => accountBloc ?? _FakeAccountBloc(),
      ),
      BlocProvider<MultiplayerBloc>(
        create: (_) =>
            mpBloc ?? MultiplayerBloc(repository: _TestMultiplayerRepo()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('id'),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multiplayer UI Pages', () {
    testWidgets('MultiplayerMainPage renders hero and action options', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithApp(child: const MultiplayerMainPage()));
      await tester.pumpAndSettle();

      expect(find.text('Bermain bersama'), findsOneWidget);
      expect(find.text('Latihan bersama teman'), findsOneWidget);
      expect(find.text('Buat Ruangan Baru'), findsOneWidget);
      expect(find.text('Gabung ruangan'), findsOneWidget);
    });

    testWidgets('MultiplayerRoomPage renders Host connect elements', (
      tester,
    ) async {
      final repo = _TestMultiplayerRepo(
        const MultiplayerGameState(phase: MultiplayerPhase.hosting),
        MultiplayerRole.host,
      );
      final mpBloc = MultiplayerBloc(repository: repo);

      await tester.pumpWidget(
        _wrapWithApp(
          child: const MultiplayerRoomPage(isHost: true),
          mpBloc: mpBloc,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Ruangan'), findsOneWidget);
      expect(find.text('ALAMAT PERANGKAT INI'), findsOneWidget);
      expect(
        find.text(
          'Pastikan kedua perangkat terhubung ke jaringan Wi-Fi yang sama.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('MultiplayerRoomPage renders Guesser connect elements', (
      tester,
    ) async {
      final repo = _TestMultiplayerRepo(
        const MultiplayerGameState(phase: MultiplayerPhase.initial),
        MultiplayerRole.guesser,
      );
      final mpBloc = MultiplayerBloc(repository: repo);

      await tester.pumpWidget(
        _wrapWithApp(
          child: const MultiplayerRoomPage(isHost: false),
          mpBloc: mpBloc,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ruangan'), findsOneWidget);
      expect(find.text('Ketuk untuk pindai QR Host'), findsOneWidget);
      expect(find.text('Masukan IP Address Host....'), findsOneWidget);
      expect(find.text('Gabung Ruangan'), findsOneWidget);
    });

    testWidgets('MultiplayerLobbyPage renders connected players', (
      tester,
    ) async {
      const host = MultiplayerPlayer(
        id: 'h1',
        name: 'Santi',
        isHost: true,
        badgeText: 'P1',
      );
      const guesser = MultiplayerPlayer(
        id: 'g1',
        name: 'Rian',
        isHost: false,
        badgeText: 'P2',
      );

      final repo = _TestMultiplayerRepo(
        const MultiplayerGameState(
          phase: MultiplayerPhase.lobby,
          hostPlayer: host,
          guesserPlayer: guesser,
        ),
        MultiplayerRole.host,
      );
      final mpBloc = MultiplayerBloc(repository: repo);

      await tester.pumpWidget(
        _wrapWithApp(child: const MultiplayerLobbyPage(), mpBloc: mpBloc),
      );
      await tester.pumpAndSettle();

      expect(find.text('Lobi latihan'), findsOneWidget);
      expect(find.text('Pemain Terhubung (2/2)'), findsOneWidget);
      expect(find.text('Santi (Host)'), findsOneWidget);
      expect(find.text('Rian'), findsOneWidget);
      expect(find.text('Pilih Deck'), findsOneWidget);
    });

    testWidgets('MultiplayerGamePage renders question and options for host', (
      tester,
    ) async {
      const question = MultiplayerQuizQuestion(
        cardId: 'c1',
        prompt:
            'Kalimat yang digunakan untuk mengungkapkan kasih sayang adalah',
        targetWord: 'i love you tu',
        options: [
          'i love you tu',
          'Halo Selamat Siang',
          'selamat pagi',
          'haii',
        ],
        correctAnswer: 'i love you tu',
      );

      final repo = _TestMultiplayerRepo(
        const MultiplayerGameState(
          phase: MultiplayerPhase.hostAnswering,
          questions: [question],
          currentQuestionIndex: 0,
        ),
        MultiplayerRole.host,
      );
      final mpBloc = MultiplayerBloc(repository: repo);

      await tester.pumpWidget(
        _wrapWithApp(child: const MultiplayerGamePage(), mpBloc: mpBloc),
      );
      await tester.pumpAndSettle();

      expect(find.text('Latihan bersama'), findsOneWidget);
      expect(find.text(question.prompt), findsOneWidget);
      expect(find.text('i love you tu'), findsOneWidget);
      expect(find.text('Halo Selamat Siang'), findsOneWidget);
    });

    testWidgets(
      'MultiplayerCompletePage renders flame, score, and kembali button',
      (tester) async {
        final repo = _TestMultiplayerRepo(
          const MultiplayerGameState(
            phase: MultiplayerPhase.completed,
            outcomes: [
              true,
              true,
              false,
              null,
              true,
              true,
              false,
              true,
              true,
              true,
            ],
            durationMs: 200000,
          ),
          MultiplayerRole.host,
        );
        final mpBloc = MultiplayerBloc(repository: repo);

        await tester.pumpWidget(
          _wrapWithApp(child: const MultiplayerCompletePage(), mpBloc: mpBloc),
        );
        await tester.pumpAndSettle();

        expect(find.text('Latihan Bersama Selesai'), findsOneWidget);
        expect(find.text('Jawaban Tepat'), findsOneWidget);
        expect(find.text('Waktu Aktif Sesi'), findsOneWidget);
        expect(find.text('Kembali'), findsOneWidget);
      },
    );
  });
}
