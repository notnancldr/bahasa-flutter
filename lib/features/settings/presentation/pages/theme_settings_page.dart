import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Implements Theme selection flow (THM-01, THM-02).
/// UI visual styling is excluded.
class ThemeSettingsPage extends StatelessWidget {
  final ThemeBloc? bloc;

  const ThemeSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    // If an ancestor ThemeBloc exists (e.g. from app root), reuse it; otherwise create one.
    try {
      context.read<ThemeBloc>();
      return const ThemeSettingsView();
    } catch (_) {
      return BlocProvider(
        create: (_) => (bloc ?? SettingsDependencies.createThemeBloc())
          ..add(const LoadThemeEvent()),
        child: const ThemeSettingsView(),
      );
    }
  }
}

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({super.key});

  void _onSelectTheme(BuildContext context, ThemeMode mode) {
    // THM-01: Choose Dark or Light Theme
    context.read<ThemeBloc>().add(ChangeThemeEvent(mode));
  }

  void _onCancel(BuildContext context) {
    // Do Nothing (return to Select Menu)
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {
        // THM-02: Change applied and return to Select Menu
        if (state.isApplied && context.canPop()) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Change Theme'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onCancel(context),
            ),
          ),
          body: SafeArea(
            child: RadioGroup<ThemeMode>(
              groupValue: state.themeMode,
              onChanged: (mode) {
                if (mode != null) _onSelectTheme(context, mode);
              },
              child: ListView(
                children: [
                  const RadioListTile<ThemeMode>(
                    title: Text('Light Theme'),
                    value: ThemeMode.light,
                  ),
                  const RadioListTile<ThemeMode>(
                    title: Text('Dark Theme'),
                    value: ThemeMode.dark,
                  ),
                  TextButton(
                    onPressed: () => _onCancel(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

