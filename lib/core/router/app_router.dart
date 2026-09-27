import 'package:bahasa/features/login/presentation/pages/login_page.dart';
import 'package:bahasa/features/login/presentation/pages/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

class AppRouter {
  // final dynamic authBloc;

  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login, // Temporary initial location
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
        builder: (context, state) => const LoginPage(),
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