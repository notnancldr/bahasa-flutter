import 'package:bahasa/features/settings/presentation/bloc/notification/notification_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/notification/notification_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Implements Notification Settings flow (NTF-01, NTF-02).
/// UI visual styling is excluded.
class NotificationSettingsPage extends StatelessWidget {
  final NotificationBloc? bloc;

  const NotificationSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (bloc ?? SettingsDependencies.createNotificationBloc())
        ..add(const LoadNotificationSettingsEvent()),
      child: const NotificationSettingsView(),
    );
  }
}

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  void _onToggleNotification(BuildContext context, bool isEnabled) {
    // NTF-01: Toggle notifications on or off
    context.read<NotificationBloc>().add(ToggleNotificationEvent(isEnabled));
  }

  void _onCancel(BuildContext context) {
    // Do Nothing (return to Select Menu)
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        // NTF-02: After choosing, user returns to Select Menu
        if (state.isApplied && context.canPop()) {
          context.pop();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onCancel(context),
            ),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: state.isEnabled,
                  onChanged: (val) => _onToggleNotification(context, val),
                ),
                TextButton(
                  onPressed: () => _onCancel(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

