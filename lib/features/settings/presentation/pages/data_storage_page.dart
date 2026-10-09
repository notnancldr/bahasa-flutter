import 'package:bahasa/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Data & Storage Options menu page.
/// Provides entry points to Share Data and Delete Data flows.
/// UI visual styling is excluded.
class DataStoragePage extends StatelessWidget {
  const DataStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DataStorageView();
  }
}

class DataStorageView extends StatelessWidget {
  const DataStorageView({super.key});

  void _navigateToShareData(BuildContext context) {
    context.push(AppRoutes.settingsDataTransfer);
  }

  void _navigateToDeleteData(BuildContext context) {
    context.push(AppRoutes.settingsDataDelete);
  }

  void _onCancel(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data & Storage Options'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _onCancel(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Share / Transfer Data'),
              subtitle: const Text('Transfer data using receiver code'),
              onTap: () => _navigateToShareData(context),
            ),
            ListTile(
              title: const Text('Delete Data'),
              subtitle: const Text('Delete application data with verification'),
              onTap: () => _navigateToDeleteData(context),
            ),
          ],
        ),
      ),
    );
  }
}

