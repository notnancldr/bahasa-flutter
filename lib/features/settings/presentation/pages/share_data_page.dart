import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Implements Share / Transfer Data flow (DAT-01, DAT-02, DAT-03).
/// Transactional transfer with temp directory, atomic persistence, and retry prompt.
/// UI visual styling is excluded.
class ShareDataPage extends StatelessWidget {
  final DataStorageBloc? bloc;

  const ShareDataPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc ?? SettingsDependencies.createDataStorageBloc(),
      child: const ShareDataView(),
    );
  }
}

class ShareDataView extends StatefulWidget {
  const ShareDataView({super.key});

  @override
  State<ShareDataView> createState() => _ShareDataViewState();
}

class _ShareDataViewState extends State<ShareDataView> {
  final TextEditingController _receiverCodeController = TextEditingController();

  @override
  void dispose() {
    _receiverCodeController.dispose();
    super.dispose();
  }

  void _onStartTransfer(BuildContext context) {
    final code = _receiverCodeController.text.trim();
    if (code.isNotEmpty) {
      context.read<DataStorageBloc>().add(StartDataTransferEvent(code));
    }
  }

  void _onCancel(BuildContext context) {
    context.read<DataStorageBloc>().add(const CancelDataTransferEvent());
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.settings);
    }
  }

  Future<void> _showFailedAlertWithRetry(
    BuildContext context,
    String errorMessage,
  ) async {
    // Flowchart: Tampilkan failed alert, tanyakan Retry? (DAT-03)
    final retry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Transfer Failed'),
        content: Text('$errorMessage\n\nWould you like to retry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // No -> back to Settings
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), // Yes -> Retry
            child: const Text('Retry'),
          ),
        ],
      ),
    );

    if (context.mounted) {
      if (retry == true) {
        context.read<DataStorageBloc>().add(const RetryDataTransferEvent());
      } else {
        context.read<DataStorageBloc>().add(const CancelDataTransferEvent());
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.settings);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataStorageBloc, DataStorageState>(
      listener: (context, state) {
        if (state is DataTransferSuccess) {
          // Flowchart: Selesai (berhasil) -> kembali ke halaman Settings dengan indikasi sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data transfer completed successfully!')),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.settings);
          }
        } else if (state is DataTransferFailureState) {
          _showFailedAlertWithRetry(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Share Data'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onCancel(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: switch (state) {
                DataTransferring(:final receiverCode) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('Transferring data to $receiverCode...'),
                      ],
                    ),
                  ),
                _ => ListView(
                    children: [
                      TextField(
                        controller: _receiverCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Receiver Code',
                          hintText: 'Enter code receiver',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _onStartTransfer(context),
                        child: const Text('Start Transfer'),
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

