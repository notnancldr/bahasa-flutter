import 'package:bahasa/core/router/page_transitions.dart';
import 'package:bahasa/core/widgets/main_scaffold.dart';
import 'package:bahasa/features/decks/deck_history/presentation/pages/deck_history_page.dart';
import 'package:bahasa/features/decks/deck_details/domain/entities/deck_progress_data.dart';
import 'package:bahasa/features/decks/deck_details/presentation/pages/deck_details_page.dart';
import 'package:bahasa/features/decks/deck_details/presentation/pages/deck_progress_page.dart';
import 'package:bahasa/features/decks/generate_deck/presentation/pages/generate_deck_page.dart';
import 'package:bahasa/features/decks/import_deck/presentation/pages/import_deck_page.dart';
import 'package:bahasa/features/decks/presentation/pages/deck_page.dart';
import 'package:bahasa/features/decks/study/presentation/pages/flashcard_page.dart';
import 'package:bahasa/features/decks/study/presentation/pages/quiz_page.dart';
import 'package:bahasa/features/home/presentation/pages/home_page.dart';
import 'package:bahasa/features/login/presentation/pages/login_page.dart';
import 'package:bahasa/features/login/presentation/pages/transfer_page.dart';
import 'package:bahasa/features/login/presentation/pages/welcome_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_complete_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_game_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_history_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_lobby_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_main_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_room_page.dart';
import 'package:bahasa/features/multiplayer/presentation/pages/multiplayer_select_deck_page.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/pages/account_settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/data_storage_page.dart';
import 'package:bahasa/features/settings/presentation/pages/edit_profile_page.dart';
import 'package:bahasa/features/settings/presentation/pages/language_settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/share_data_page.dart';
import 'package:bahasa/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home, // Temporary initial location
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: "login",
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.loginNew,
        name: "loginNew",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginTransfer,
        name: "loginTransfer",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const TransferPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckGenerate,
        name: "deckGenerate",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const GenerateDeckPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckImport,
        name: "deckImport",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const ImportDeckPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckDetails,
        name: "deckDetails",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: DeckDetailsPage(deckId: state.pathParameters['deckId'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckStreak,
        name: "deckStreak",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: DeckProgressPage(
            deckId: state.pathParameters['deckId'] ?? '',
            metricType: DeckProgressMetricType.streak,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckAccuracy,
        name: "deckAccuracy",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: DeckProgressPage(
            deckId: state.pathParameters['deckId'] ?? '',
            metricType: DeckProgressMetricType.accuracy,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckFlashcard,
        name: "deckFlashcard",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: FlashcardPage(deckId: state.pathParameters['deckId'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckQuiz,
        name: "deckQuiz",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: QuizPage(deckId: state.pathParameters['deckId'] ?? ''),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckDetailsHistory,
        name: "deckDetailsHistory",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: DeckHistoryPage(deckId: state.pathParameters['deckId']),
        ),
      ),
      GoRoute(
        path: AppRoutes.deckHistory,
        name: "deckHistory",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const DeckHistoryPage(),
        ),
      ),

      StatefulShellRoute(
        branches: [
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: "home",
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutes.multiplayer,
                name: "multiplayer",
                builder: (context, state) => const MultiplayerMainPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutes.deck,
                name: "deck",
                builder: (context, state) => const DeckPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: "settings",
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return MainScaffold(
            navigationShell: navigationShell,
            children: children,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.multiplayerRoom,
        name: "multiplayerRoom",
        pageBuilder: (context, state) {
          final isHost =
              (state.extra as Map<String, dynamic>?)?['isHost'] as bool? ??
              true;
          return buildSlideTransitionPage(
            context: context,
            state: state,
            child: MultiplayerRoomPage(isHost: isHost),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.multiplayerLobby,
        name: "multiplayerLobby",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const MultiplayerLobbyPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.multiplayerSelectDeck,
        name: "multiplayerSelectDeck",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const MultiplayerSelectDeckPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.multiplayerGame,
        name: "multiplayerGame",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const MultiplayerGamePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.multiplayerComplete,
        name: "multiplayerComplete",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const MultiplayerCompletePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.multiplayerHistory,
        name: "multiplayerHistory",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const MultiplayerHistoryPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsAccount,
        name: "settingsAccount",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: AccountSettingsPage(bloc: state.extra as AccountBloc?),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsAccountEdit,
        name: "settingsAccountEdit",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: EditProfilePage(bloc: state.extra as AccountBloc?),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsTheme,
        name: "settingsTheme",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const ThemeSettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsLanguage,
        name: "settingsLanguage",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: LanguageSettingsPage(bloc: state.extra as AccountBloc?),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsDataStorage,
        name: "settingsDataStorage",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const DataStoragePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsDataTransfer,
        name: "settingsDataTransfer",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const ShareDataPage(),
        ),
      ),
    ],
  );
}
