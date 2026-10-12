import 'package:bahasa/core/localization/locale_cubit.dart';
import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider(
          create: (_) => SettingsDependencies.createThemeBloc()
            ..add(const LoadThemeEvent()),
        ),
      ],
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LanguageState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              title: AppLocalizations.of(context)?.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: localeState.locale,
              debugShowCheckedModeBanner: false,
              themeMode: themeState.themeMode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              routerConfig: _appRouter.router,
            );
          },
        );
      },
    );
  }
}