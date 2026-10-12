import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/l10n/app_localizations.dart';
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
    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: const BahasaApp(),
    );
  }
}

class BahasaApp extends StatefulWidget {
  const BahasaApp({super.key});

  @override
  State<BahasaApp> createState() => _BahasaAppState();
}

class _BahasaAppState extends State<BahasaApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: AppLocalizations.of(context)?.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state.locale,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.light,
          routerConfig: _appRouter.router,
        );
      }
    );
  }
}