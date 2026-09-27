import 'package:bahasa/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppBootstrap());
}

/// Wires up repositories and app-wide blocs before the app itself is built.
class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiRepositoryProvider(
    //   providers: [
    //     // RepositoryProvider<AuthRepository>(
    //     //   create: (_) => AuthRepository(),
    //     // ),
    //     // add other repositories here (e.g. UserRepository, ApiClient)
    //   ],
    //   child: MultiBlocProvider(
    //     providers: [
    //       BlocProvider<AuthBloc>(
    //         create: (context) => AuthBloc(
    //           authRepository: context.read<AuthRepository>(),
    //         )..add(const AuthCheckRequested()),
    //       ),
    //       // add other app-wide blocs here
    //     ],
    //     child: const MyApp(),
    //   ),
    // );
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      routerConfig: _appRouter.router,
    );
  }
}