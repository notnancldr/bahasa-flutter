import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/waiting_dots.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/qr_scanner_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../bloc/multiplayer_state.dart';

/// Screen managing initial room connection: Host QR & IP broadcast, or Guesser camera QR scan & IP input.
class MultiplayerRoomPage extends StatefulWidget {
  final bool isHost;

  const MultiplayerRoomPage({super.key, required this.isHost});

  @override
  State<MultiplayerRoomPage> createState() => _MultiplayerRoomPageState();
}

class _MultiplayerRoomPageState extends State<MultiplayerRoomPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final accountState = context.read<AccountBloc>().state;
      var username = 'Player';
      if (accountState is AccountLoaded &&
          accountState.profile.username.trim().isNotEmpty) {
        username = accountState.profile.username.trim();
      }

      if (widget.isHost) {
        context.read<MultiplayerBloc>().add(
          StartHostRoomEvent(hostName: username),
        );
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  void _onJoinPressed(BuildContext context) {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) return;

    final accountState = context.read<AccountBloc>().state;
    var username = 'Player 2';
    if (accountState is AccountLoaded &&
        accountState.profile.username.trim().isNotEmpty) {
      username = accountState.profile.username.trim();
    }

    context.read<MultiplayerBloc>().add(
      JoinRoomEvent(hostAddress: ip, guesserName: username),
    );
  }

  Future<void> _handleScanQr() async {
    final scanned = await QrScannerModal.show(context);
    if (!mounted) return;
    if (scanned != null && scanned.trim().isNotEmpty) {
      _ipController.text = scanned.trim();
      _onJoinPressed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<MultiplayerBloc, MultiplayerState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state.phase == MultiplayerPhase.lobby) {
          context.pushReplacement(AppRoutes.multiplayerLobby);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: CircleBackButton(
                  onPressed: () {
                    context.read<MultiplayerBloc>().add(
                      const LeaveMultiplayerEvent(),
                    );
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.multiplayer);
                    }
                  },
                ),
              ),
            ),
            title: Text(
              l.multiplayer_room_title,
              style: t.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Icon(
                    Symbols.history,
                    size: 20,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                tooltip: l.multiplayer_history_title,
                onPressed: () => context.push(AppRoutes.multiplayerHistory),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: widget.isHost
                ? _buildHostView(context, state)
                : _buildGuesserView(context, state),
          ),
        );
      },
    );
  }

  Widget _buildHostView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ipHost = state.hostIp ?? '...';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // IP Address Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2E3846)
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.multiplayer_room_ip_label,
                  style: t.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ipHost,
                      style: t.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: ipHost));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(l.copied)));
                      },
                      icon: const Icon(Symbols.content_copy, size: 18),
                      label: Text(l.copy),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF4A5568)
                              : const Color(0xFFCBD5E1),
                        ),
                        foregroundColor: s.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // QR Code Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2E3846)
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                // Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2D3748)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.qr_code_scanner,
                        size: 16,
                        color: s.primaryDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l.multiplayer_room_scan_label,
                        style: t.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // QR Container
                Container(
                  width: 180,
                  height: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PrettyQrView.data(
                    data: 'http://$ipHost:7001',
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                WaitingDots(color: c.primary),
                const SizedBox(height: 12),

                Text(
                  l.multiplayer_room_waiting,
                  style: t.bodyMedium?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Wi-Fi note card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2630) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Symbols.wifi, size: 20, color: s.primaryDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.multiplayer_room_wifi_note,
                    style: t.bodySmall?.copyWith(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuesserView(BuildContext context, MultiplayerState state) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Camera scanner tap area
          GestureDetector(
            onTap: _handleScanQr,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E2630)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF7CB8C9),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.photo_camera,
                    size: 48,
                    color: const Color(0xFF5BA4B8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.multiplayer_join_scan_qr,
                    style: t.bodyMedium?.copyWith(
                      color: const Color(0xFF5BA4B8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Divider text
          Text(
            l.multiplayer_join_or_scan,
            style: t.bodySmall?.copyWith(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          // IP text input field
          TextField(
            controller: _ipController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: l.multiplayer_join_ip_placeholder,
              filled: true,
              fillColor: isDark ? const Color(0xFF1E2630) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFF2E3846)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFF2E3846)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.primary, width: 1.5),
              ),
            ),
            onSubmitted: (_) => _onJoinPressed(context),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: EmbossedButton(
              state.isLoading ? '...' : l.multiplayer_join_button,
              type: EmbossedButtonType.filled,
              onPressed: state.isLoading ? null : () => _onJoinPressed(context),
            ),
          ),
        ],
      ),
    );
  }
}
