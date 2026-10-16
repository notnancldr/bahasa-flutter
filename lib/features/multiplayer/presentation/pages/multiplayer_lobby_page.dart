import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/waiting_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../bloc/multiplayer_state.dart';
import '../widgets/multiplayer_player_card.dart';

/// Lobby screen displaying connected players (2/2) before starting the quiz.
class MultiplayerLobbyPage extends StatelessWidget {
  const MultiplayerLobbyPage({super.key});

  void _onLeave(BuildContext context) {
    context.read<MultiplayerBloc>().add(const LeaveMultiplayerEvent());
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.multiplayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<MultiplayerBloc, MultiplayerState>(
      listener: (context, state) {
        if (state.phase == MultiplayerPhase.hostAnswering ||
            state.phase == MultiplayerPhase.guesserTurn) {
          context.pushReplacement(AppRoutes.multiplayerGame);
        } else if (state.phase == MultiplayerPhase.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Disconnected')),
          );
          context.go(AppRoutes.multiplayer);
        }
      },
      builder: (context, state) {
        final host = state.game.hostPlayer;
        final guesser = state.game.guesserPlayer;

        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: CircleBackButton(onPressed: () => _onLeave(context)),
              ),
            ),
            title: Text(
              l.multiplayer_lobby_title,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.multiplayer_lobby_connected_count(
                      guesser != null ? 2 : 1,
                      2,
                    ),
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2 Cards Row
                  Row(
                    children: [
                      if (guesser != null)
                        Expanded(child: MultiplayerPlayerCard(player: guesser))
                      else
                        const Expanded(child: SizedBox.shrink()),
                      const SizedBox(width: 16),
                      if (host != null)
                        Expanded(child: MultiplayerPlayerCard(player: host))
                      else
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  ),

                  const Spacer(),

                  // Bottom action / waiting
                  if (state.isHost) ...[
                    SizedBox(
                      width: double.infinity,
                      child: EmbossedButton(
                        l.multiplayer_lobby_start_button,
                        type: EmbossedButtonType.filled,
                        onPressed: () =>
                            context.push(AppRoutes.multiplayerSelectDeck),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WaitingDots(color: c.primary),
                          const SizedBox(height: 12),
                          Text(
                            l.multiplayer_lobby_waiting_host,
                            style: t.bodyMedium?.copyWith(
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
