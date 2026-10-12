import 'package:bahasa/core/router/page_transitions.dart';
import 'package:bahasa/features/login/presentation/pages/login_page.dart';
import 'package:bahasa/features/login/presentation/pages/transfer_page.dart';
import 'package:bahasa/features/login/presentation/pages/welcome_page.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/pages/account_settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/data_storage_page.dart';
import 'package:bahasa/features/settings/presentation/pages/edit_profile_page.dart';
import 'package:bahasa/features/settings/presentation/pages/settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/share_data_page.dart';
import 'package:bahasa/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login, // Temporary initial location
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

      // Settings routes
      GoRoute(
        path: AppRoutes.settings,
        name: "settings",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsAccount,
        name: "settingsAccount",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const AccountSettingsPage(),
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
