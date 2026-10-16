import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../bloc/deck_details_bloc.dart';
import '../bloc/deck_details_event.dart';
import '../bloc/deck_details_state.dart';
import '../widgets/card_detail_bottom_sheet.dart';
import '../widgets/deck_activity_summary_row.dart';
import '../widgets/deck_card_list_section.dart';
import '../widgets/deck_details_hero_banner.dart';
import '../widgets/deck_game_buttons_row.dart';

/// Page displaying a deck's details, game entry buttons (Quiz & Flash Card),
/// per-deck Streak and Accuracy summary metrics, searchable cards list,
/// and Card Detail bottom sheet.
class DeckDetailsPage extends StatelessWidget {
  /// Target deck identifier.
  final String deckId;

  /// Optional [DeckDetailsBloc] override for testing.
  final DeckDetailsBloc? bloc;

  /// Creates a [DeckDetailsPage].
  const DeckDetailsPage({super.key, required this.deckId, this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeckDetailsBloc>(
      create: (_) =>
          (bloc ?? DecksDependencies.createDeckDetailsBloc())
            ..add(LoadDeckDetailsEvent(deckId)),
      child: _DeckDetailsView(deckId: deckId),
    );
  }
}

class _DeckDetailsView extends StatefulWidget {
  final String deckId;

  const _DeckDetailsView({required this.deckId});

  @override
  State<_DeckDetailsView> createState() => _DeckDetailsViewState();
}

class _DeckDetailsViewState extends State<_DeckDetailsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pushAndRefresh(String routePath) async {
    await context.push(routePath);
    if (mounted) {
      context.read<DeckDetailsBloc>().add(LoadDeckDetailsEvent(widget.deckId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l) = WidgetVars.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DeckDetailsBloc, DeckDetailsState>(
          builder: (context, state) {
            return switch (state) {
              DeckDetailsInitial() || DeckDetailsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              DeckDetailsError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.read<DeckDetailsBloc>().add(
                          LoadDeckDetailsEvent(widget.deckId),
                        ),
                        child: Text(l.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
              DeckDetailsLoaded(:final data, :final filteredCards) =>
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<DeckDetailsBloc>().add(
                      LoadDeckDetailsEvent(widget.deckId),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top bar: Back button & History icon button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleBackButton(),
                            IconButton(
                              onPressed: () {
                                context.push(
                                  AppRoutes.deckHistoryPath(widget.deckId),
                                );
                              },
                              tooltip: l.deck_details_history_tooltip,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(42, 42),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.4,
                                ),
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(
                                Symbols.history,
                                size: 20,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Hero Flag & Deck Banner
                        DeckDetailsHeroBanner(deck: data.deck),
                        const SizedBox(height: 16),

                        // Play Quiz & Play Flash Card buttons
                        DeckGameButtonsRow(
                          onPlayQuiz: data.cards.isEmpty
                              ? null
                              : () => _pushAndRefresh(
                                  AppRoutes.deckQuizPath(widget.deckId),
                                ),
                          onPlayFlashcard: data.cards.isEmpty
                              ? null
                              : () => _pushAndRefresh(
                                  AppRoutes.deckFlashcardPath(widget.deckId),
                                ),
                        ),
                        const SizedBox(height: 18),

                        // Streak & Accuracy summary metrics
                        DeckActivitySummaryRow(
                          streakCount: data.streakCount,
                          accuracyPercent: data.accuracyPercent,
                          onTapStreak: () => _pushAndRefresh(
                            AppRoutes.deckStreakPath(widget.deckId),
                          ),
                          onTapAccuracy: () => _pushAndRefresh(
                            AppRoutes.deckAccuracyPath(widget.deckId),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card search bar & card list
                        DeckCardListSection(
                          searchController: _searchController,
                          onSearchChanged: (query) => context
                              .read<DeckDetailsBloc>()
                              .add(SearchDeckCardsChangedEvent(query)),
                          cards: filteredCards,
                          onCardTap: (card) =>
                              CardDetailBottomSheet.show(context, card),
                        ),
                      ],
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
