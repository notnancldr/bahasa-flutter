import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/features/decks/presentation/widgets/deck_card.dart';
import 'package:bahasa/features/decks/presentation/widgets/deck_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../bloc/multiplayer_state.dart';

/// Screen allowing the host to select which deck to practice in the multiplayer quiz.
class MultiplayerSelectDeckPage extends StatefulWidget {
  const MultiplayerSelectDeckPage({super.key});

  @override
  State<MultiplayerSelectDeckPage> createState() =>
      _MultiplayerSelectDeckPageState();
}

class _MultiplayerSelectDeckPageState extends State<MultiplayerSelectDeckPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MultiplayerBloc>().add(const LoadMultiplayerDecksEvent());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<MultiplayerBloc, MultiplayerState>(
      listener: (context, state) {
        if (state.phase == MultiplayerPhase.hostAnswering) {
          context.pushReplacement(AppRoutes.multiplayerGame);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final filteredDecks = state.filteredDecks;

        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Center(
                child: CircleBackButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.multiplayerLobby);
                    }
                  },
                ),
              ),
            ),
            title: Text(
              l.multiplayer_select_deck_title,
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  DeckSearchBar(
                    controller: _searchController,
                    onChanged: (val) {
                      context.read<MultiplayerBloc>().add(
                        FilterMultiplayerDecksEvent(val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredDecks.isEmpty
                        ? Center(
                            child: Text(
                              l.deck_empty_search_title,
                              style: t.titleMedium,
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: filteredDecks.length,
                            itemBuilder: (context, index) {
                              final deck = filteredDecks[index];
                              return DeckCard(
                                key: ValueKey(deck.id),
                                deck: deck,
                                isSelectionMode: false,
                                isSelected: false,
                                onLongPress: () {},
                                onTap: () {
                                  context.read<MultiplayerBloc>().add(
                                    SelectMultiplayerDeckEvent(deck.id),
                                  );
                                },
                              );
                            },
                          ),
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
