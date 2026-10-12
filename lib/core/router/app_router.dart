import 'package:bahasa/core/router/page_transitions.dart';
import 'package:bahasa/features/login/presentation/pages/login_page.dart';
import 'package:bahasa/features/login/presentation/pages/transfer_page.dart';
import 'package:bahasa/features/login/presentation/pages/welcome_page.dart';
import 'package:bahasa/features/settings/presentation/pages/account_settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/data_storage_page.dart';
import 'package:bahasa/features/settings/presentation/pages/delete_data_page.dart';
import 'package:bahasa/features/settings/presentation/pages/notification_settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/settings_page.dart';
import 'package:bahasa/features/settings/presentation/pages/share_data_page.dart';
import 'package:bahasa/features/settings/presentation/pages/theme_settings_page.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

class AppRouter {
  // final dynamic authBloc;

  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.settings, // Temporary initial location
    debugLogDiagnostics: true,
    // refreshListenable: GoRouterRefreshStream(authBloc.stream),
    // redirect: _handleRedirect,
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
        path: AppRoutes.settingsTheme,
        name: "settingsTheme",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const ThemeSettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settingsNotifications,
        name: "settingsNotifications",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const NotificationSettingsPage(),
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
      GoRoute(
        path: AppRoutes.settingsDataDelete,
        name: "settingsDataDelete",
        pageBuilder: (context, state) => buildSlideTransitionPage(
          context: context,
          state: state,
          child: const DeleteDataPage(),
        ),
      ),

      // Shell route: persistent scaffold (e.g. bottom nav) for main app
      // ShellRoute(
      //   builder: (context, state, child) => MainShell(child: child),
      //   routes: [
      //     GoRoute(
      //       path: AppRoutes.home,
      //       name: 'home',
      //       builder: (context, state) => const HomePage(),
      //       routes: [
      //         GoRoute(
      //           path: 'details/:id',
      //           name: 'details',
      //           builder: (context, state) {
      //             final id = state.pathParameters['id']!;
      //             return DetailsPage(id: id);
      //           },
      //         ),
      //       ],
      //     ),
      //     GoRoute(
      //       path: AppRoutes.profile,
      //       name: 'profile',
      //       builder: (context, state) => const ProfilePage(),
      //     ),
      //   ],
      // ),
    ],
    // errorBuilder: (context, state) => ErrorPage(error: state.error), // TODO
  );

  // FutureOr<String?> _handleRedirect(
  //   BuildContext context,
  //   GoRouterState state,
  // ) {
  //   final isLoggedIn = authBloc.state is AuthAuthenticated; // adapt to your states
  //   final isAuthRoute = state.matchedLocation == AppRoutes.login ||
  //       state.matchedLocation == AppRoutes.splash;

  //   if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
  //   if (isLoggedIn && isAuthRoute) return AppRoutes.home;
  //   return null; // no redirect
  // }
}