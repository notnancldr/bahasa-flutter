import 'dart:ui';

import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/core/widgets/scale_fade_switcher.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_alert_dialog.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/share_data_input_step.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/share_data_transmitting_step.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  final TextEditingController _receiveIpController = TextEditingController();

  static int _stepFor(DataStorageState state) {
    return switch (state) {
      DataTransferring() => 1,
      _ => 0,
    };
  }

  @override
  void dispose() {
    _receiveIpController.dispose();
    super.dispose();
  }

  void _onStartTransfer(BuildContext context) {
    final ip = _receiveIpController.text.trim();
    if (ip.isNotEmpty) {
      context.read<DataStorageBloc>().add(StartDataTransferEvent(ip));
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
    final WidgetVars(:c, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final retry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (dialogCtx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: SettingsAlertDialog(
          icon: Symbols.priority_high,
          iconColor: const Color(0xFFC62828),
          iconBackgroundColor: isDark
              ? const Color(0xFF381E1E)
              : const Color(0xFFFDE8E8),
          title: l.shareData_failed_title,
          message: l.shareData_failed_body,
          actions: [
            EmbossedButton(
              l.shareData_failed_no,
              type: EmbossedButtonType.outlined,
              color: EmbossedButtonColor(
                border: c.primary,
                foreground: c.primary,
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(false),
            ),
            EmbossedButton(
              l.tryAgain,
              type: EmbossedButtonType.filled,
              color: const EmbossedButtonColor(
                background: Color(0xFFA8D5E2),
                foreground: Color(0xFF1D4A5C),
                shadow: Color(0xFF7CB8C9),
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
            ),
          ],
        ),
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
    final WidgetVars(:isDark) = WidgetVars.of(context);

    return BlocConsumer<DataStorageBloc, DataStorageState>(
      listener: (context, state) {
        if (state is DataTransferSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data transfer completed successfully!'),
            ),
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
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(child: _buildSwitcher(context, state)),
        );
      },
    );
  }

  Widget _buildSwitcher(BuildContext context, DataStorageState state) {
    return ScaleFadeSwitcher(
      child: switch (_stepFor(state)) {
        1 => ShareDataTransmittingStep(
          key: const ValueKey('share-data-transmitting-step'),
          onCancel: () => _onCancel(context),
        ),
        _ => ShareDataInputStep(
          key: const ValueKey('share-data-input-step'),
          controller: _receiveIpController,
          onStartTransfer: () => _onStartTransfer(context),
        ),
      },
    );
  }
}
