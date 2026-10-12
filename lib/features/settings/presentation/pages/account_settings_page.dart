import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Implements Account Options & Profile Edit / Delete flow (ACC-01 through ACC-07).
/// Presentation UI design is excluded, focusing purely on functional and state wiring.
class AccountSettingsPage extends StatelessWidget {
  final AccountBloc? bloc;

  const AccountSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => (bloc ?? SettingsDependencies.createAccountBloc())
        ..add(const LoadAccountEvent()),
      child: const AccountSettingsView(),
    );
  }
}

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onPickPhoto(BuildContext context) {
    // ACC-02: Access phone files, select image, and return to profile options
    context.read<AccountBloc>().add(const PickAndChangePhotoEvent());
  }

  void _onSubmitUsername(BuildContext context) {
    // ACC-03: Change username and return to profile options
    final newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      context.read<AccountBloc>().add(ChangeUsernameEvent(newUsername));
    }
  }

  void _onCancel(BuildContext context) {
    // ACC-04, ACC-07: Do Nothing (cancel without changes)
    context.read<AccountBloc>().add(const CancelAccountActionEvent());
    if (context.canPop()) {
      context.pop();
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // ACC-05: Show "Are you sure?" confirmation before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (context.mounted) {
      if (confirmed == true) {
        // ACC-06: Confirmed -> Delete profile and all app data
        context.read<AccountBloc>().add(const ConfirmDeleteProfileEvent());
      } else {
        // ACC-07: Rejected -> Do Nothing
        context.read<AccountBloc>().add(const CancelAccountActionEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountDeletedSuccess) {
          // ACC-06: Show success alert and navigate to Login page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile and data deleted successfully.')),
          );
          context.go(AppRoutes.login);
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AccountLoaded) {
          _usernameController.text = state.profile.username;
        } else if (state is AccountPhotoUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated.')),
          );
        } else if (state is AccountUsernameUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username updated.')),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              context.read<AccountBloc>().add(const CancelAccountActionEvent());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Account Options'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _onCancel(context),
              ),
            ),
            body: SafeArea(
              child: switch (state) {
                AccountLoading() || AccountDeleting() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                _ => ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Section A: Edit Profile (ACC-01, ACC-02, ACC-03)
                      ListTile(
                        title: const Text('Change Profile Photo'),
                        subtitle: Text(
                          state is AccountLoaded
                              ? state.profile.photoPath ?? 'No photo'
                              : '',
                        ),
                        onTap: () => _onPickPhoto(context),
                      ),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Username'),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSubmitUsername(context),
                        child: const Text('Save Username'),
                      ),

                      const Divider(),

                      // Section B: Delete Profile (ACC-05, ACC-06, ACC-07)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => _showDeleteConfirmation(context),
                        child: const Text('Delete Profile'),
                      ),

                      TextButton(
                        onPressed: () => _onCancel(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
              },
            ),
          ),
        );
      },
    );
  }
}

