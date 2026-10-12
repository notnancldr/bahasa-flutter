import 'dart:ui';

import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/data_storage/data_storage_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/delete_all_data_dialog.dart';
import 'package:bahasa/features/settings/presentation/widgets/delete_success_dialog.dart';
import 'package:bahasa/features/settings/presentation/widgets/settings_menu_tile.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class DataStoragePage extends StatelessWidget {
  final DataStorageBloc? bloc;

  const DataStoragePage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => bloc ?? SettingsDependencies.createDataStorageBloc(),
        ),
        BlocProvider(
          create: (_) =>
              SettingsDependencies.createAccountBloc()
                ..add(const LoadAccountEvent()),
        ),
      ],
      child: const DataStorageView(),
    );
  }
}

class DataStorageView extends StatefulWidget {
  const DataStorageView({super.key});

  @override
  State<DataStorageView> createState() => _DataStorageViewState();
}

class _DataStorageViewState extends State<DataStorageView> {
  void _showDeleteDataDialog(BuildContext context, String currentUsername) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (dialogCtx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: DeleteAllDataDialog(
          expectedUsername: currentUsername,
          onCancel: () {
            context.read<DataStorageBloc>().add(const CancelDeleteDataEvent());
            Navigator.of(dialogCtx).pop();
          },
          onConfirm: () {
            Navigator.of(dialogCtx).pop();
            // Dispatch confirmation and verification execution
            context.read<DataStorageBloc>().add(
              const ConfirmDeleteDataFirstStepEvent(),
            );
            context.read<DataStorageBloc>().add(
              VerifyAndExecuteDeleteDataEvent(currentUsername),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          DeleteSuccessDialog(onGoHome: () => context.go(AppRoutes.home)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<DataStorageBloc, DataStorageState>(
      listener: (context, state) {
        if (state is DeleteDataSuccess) {
          _showDeleteSuccessDialog(context);
        } else if (state is DeleteDataFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(title: l.settings_title),
                  const SizedBox(height: 24),

                  Text(
                    l.settings_data_title,
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: c.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Penggunaan Penyimpanan
                  _SectionLabel(
                    title: l.data_sectionStorage,
                    color: const Color(0xFF9AA3A7),
                  ),
                  const SizedBox(height: 8),

                  SettingsMenuTile(
                    icon: Symbols.database,
                    iconColor: const Color(0xFF3B7A8C),
                    iconBackgroundColor: isDark
                        ? const Color(0xFF1E2F38)
                        : const Color(0xFFD6EFF8),
                    title: l.data_download,
                    subtitle: l.data_downloadSubtitle("128 MB"),
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${l.data_clear} selesai')),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l.data_clear,
                        style: const TextStyle(
                          color: Color(0xFF3E6E85),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Privasi & Personalisasi
                  _SectionLabel(
                    title: l.data_sectionDataTransfer,
                    color: const Color(0xFF9AA3A7),
                  ),
                  const SizedBox(height: 8),

                  Card.outlined(
                    color: isDark ? const Color(0xFF1E2630) : Colors.white,
                    child: Column(
                      children: [
                        SettingsMenuTile(
                          border: false,
                          background: false,
                          icon: Symbols.share,
                          iconColor: const Color(0xFFB5703E),
                          iconBackgroundColor: const Color(0xFFFFE3D0),
                          title: l.data_dataTransfer,
                          subtitle: l.data_dataTransfer_subtitle,
                          onTap: () {
                            context.push(AppRoutes.settingsDataTransfer);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 3: Tindakan Lanjutan
                  _SectionLabel(
                    title: l.data_sectionDanger,
                    color: const Color(0xFFC62828),
                  ),
                  const SizedBox(height: 8),

                  BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, accountState) {
                      String currentUsername = 'Rizky_23';
                      if (accountState is AccountLoaded) {
                        currentUsername =
                            accountState.profile.username.isNotEmpty
                            ? accountState.profile.username
                            : currentUsername;
                      }

                      return SettingsMenuTile(
                        icon: Symbols.delete,
                        iconColor: const Color(0xFFC62828),
                        iconBackgroundColor: isDark
                            ? const Color(0xFF381E1E)
                            : const Color(0xFFFDE8E8),
                        title: l.data_deleteData,
                        subtitle: l.data_deleteData_subtitle,
                        trailing: const Icon(
                          Symbols.chevron_right,
                          size: 20,
                          color: Color(0xFFC62828),
                        ),
                        onTap: () =>
                            _showDeleteDataDialog(context, currentUsername),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionLabel({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
