import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Implements Delete Data flow (DAT-04, DAT-05, DAT-06, DAT-07).
/// Double confirmation and username verification before deleting application data.
/// UI visual styling is excluded.
class DeleteDataPage extends StatelessWidget {
  final DataStorageBloc? bloc;

  const DeleteDataPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc ?? SettingsDependencies.createDataStorageBloc(),
      child: const DeleteDataView(),
    );
  }
}

class DeleteDataView extends StatefulWidget {
  const DeleteDataView({super.key});

  @override
  State<DeleteDataView> createState() => _DeleteDataViewState();
}

class _DeleteDataViewState extends State<DeleteDataView> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onCancel(BuildContext context) {
    // DAT-07: Cancel at any step -> Do Nothing
    context.read<DataStorageBloc>().add(const CancelDeleteDataEvent());
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.settings);
    }
  }

  Future<void> _showFirstConfirmation(BuildContext context) async {
    // DAT-04: Confirmation 1: "Are you sure to delete data?"
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Data'),
        content: const Text('Are you sure you want to delete all application data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (context.mounted) {
      if (confirmed == true) {
        context.read<DataStorageBloc>().add(const ConfirmDeleteDataFirstStepEvent());
      } else {
        _onCancel(context);
      }
    }
  }

  void _onVerifyAndSubmit(BuildContext context) {
    // DAT-05: User types username as final verification
    final enteredUsername = _usernameController.text.trim();
    if (enteredUsername.isNotEmpty) {
      context.read<DataStorageBloc>().add(
            VerifyAndExecuteDeleteDataEvent(enteredUsername),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataStorageBloc, DataStorageState>(
      listener: (context, state) {
        if (state is DeleteDataSuccess) {
          // DAT-06: Tampilkan finish alert dan arahkan ke Home
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Application data deleted successfully.')),
          );
          context.go(AppRoutes.home);
        } else if (state is DeleteDataFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Delete Data'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onCancel(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: switch (state) {
                DeletingDataInProgress() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                DeleteDataUsernameVerificationPrompt() => ListView(
                    children: [
                      // DAT-05: Final verification step
                      const Text(
                        'Final Verification: Please type your username to confirm data deletion.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your current username',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => _onVerifyAndSubmit(context),
                        child: const Text('Confirm & Delete Data'),
                      ),
                      TextButton(
                        onPressed: () => _onCancel(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                _ => ListView(
                    children: [
                      // DAT-04: Initial trigger for double confirmation
                      const Text(
                        'This will permanently delete all application data.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => _showFirstConfirmation(context),
                        child: const Text('Delete Data'),
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

