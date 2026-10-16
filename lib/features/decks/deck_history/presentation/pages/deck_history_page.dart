import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_history_item.dart';
import '../bloc/deck_history_bloc.dart';
import '../bloc/deck_history_event.dart';
import '../bloc/deck_history_state.dart';
import '../widgets/deck_history_activity_list.dart';
import '../widgets/deck_history_details_sheet.dart';
import '../widgets/deck_history_period_toggle.dart';
import '../widgets/deck_history_summary_card.dart';

/// Full screen page displaying study activity history and performance summaries.
///
/// Features a period filter toggle ("Minggu ini", "Bulan ini", "Tahun ini"),
/// a 3-metric summary row, and a list of study sessions that can be tapped to
/// inspect card-by-card question logs.
class DeckHistoryPage extends StatelessWidget {
  /// Target deck identifier, or null for cross-deck history.
  final String? deckId;

  /// Optional [DeckHistoryBloc] override for testing.
  final DeckHistoryBloc? bloc;

  /// Creates a [DeckHistoryPage].
  const DeckHistoryPage({super.key, this.deckId, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider<DeckHistoryBloc>.value(
        value: bloc!,
        child: _DeckHistoryView(deckId: deckId),
      );
    }
    return BlocProvider<DeckHistoryBloc>(
      create: (_) =>
          DecksDependencies.createDeckHistoryBloc(initialDeckId: deckId)
            ..add(LoadDeckHistory(deckId: deckId)),
      child: _DeckHistoryView(deckId: deckId),
    );
  }
}

class _DeckHistoryView extends StatelessWidget {
  final String? deckId;

  const _DeckHistoryView({this.deckId});

  Future<void> _openSessionDetails(
    BuildContext context,
    DeckHistoryItem session,
  ) async {
    final bloc = context.read<DeckHistoryBloc>();
    bloc.add(
      LoadSessionLogs(deckId: session.deckId, sessionId: session.sessionId),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<DeckHistoryBloc, DeckHistoryState>(
          builder: (context, state) {
            final isCurrent = state.selectedSessionId == session.sessionId;
            return DeckHistoryDetailsSheet(
              session: session,
              cardLogs: isCurrent ? state.sessionLogs : const [],
              isLoading: isCurrent && state.isLoadingLogs,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :c, :l) = WidgetVars.of(context);

    return Scaffold(
      backgroundColor: c.surface,
      body: SafeArea(
        child: BlocBuilder<DeckHistoryBloc, DeckHistoryState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DeckHistoryBloc>().add(
                  LoadDeckHistory(deckId: deckId, period: state.period),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar: Back Button, Title, and Refresh/History Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleBackButton(),
                        Text(
                          l.deck_history_title,
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: c.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<DeckHistoryBloc>().add(
                              LoadDeckHistory(
                                deckId: deckId,
                                period: state.period,
                              ),
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
                    const SizedBox(height: 18),

                    // Period Toggle: Minggu ini, Bulan ini, Tahun ini
                    DeckHistoryPeriodToggle(
                      activePeriod: state.period,
                      onPeriodChanged: (period) {
                        context.read<DeckHistoryBloc>().add(
                          ChangeHistoryPeriod(period),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Summary Card: Sesi, Waktu, Akurasi
                    DeckHistorySummaryCard(
                      period: state.period,
                      summary: state.summary,
                    ),
                    const SizedBox(height: 22),

                    // Activity List: Aktifitas Belajar
                    if (state.status == DeckHistoryStatus.loading &&
                        state.items.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      DeckHistoryActivityList(
                        items: state.items,
                        onSessionTap: (item) =>
                            _openSessionDetails(context, item),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
