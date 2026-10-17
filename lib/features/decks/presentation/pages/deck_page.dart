import 'dart:ui';

import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:bahasa/features/home/presentation/widgets/home_empty_state.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/deck_bloc.dart';
import '../bloc/deck_event.dart';
import '../bloc/deck_state.dart';
import '../widgets/add_deck_method_modal.dart';
import '../widgets/deck_add_fab.dart';
import '../widgets/deck_card.dart';
import '../widgets/deck_search_bar.dart';
import '../widgets/deck_selection_bottom_bar.dart';
import '../widgets/deck_selection_header_bar.dart';
import '../widgets/delete_decks_dialog.dart';
import '../widgets/generating_deck_placeholder_card.dart';
import '../../generate_deck/presentation/bloc/generate_deck_bloc.dart';
import '../../generate_deck/presentation/bloc/generate_deck_state.dart';

/// Page displaying the user's flashcard deck compilation with search,
/// flag-seeded card colors, multi-selection mode, and username-confirmed deletion.
class DeckPage extends StatelessWidget {
  /// Optional [DeckBloc] override for testing.
  final DeckBloc? bloc;

  /// Optional [AccountBloc] override for testing.
  final AccountBloc? accountBloc;

  /// Creates a [DeckPage].
  const DeckPage({super.key, this.bloc, this.accountBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (bloc != null)
          BlocProvider<DeckBloc>.value(value: bloc!)
        else
          BlocProvider<DeckBloc>(
            create: (_) =>
                DecksDependencies.createDeckBloc()..add(const LoadDecksEvent()),
          ),
        if (accountBloc != null)
          BlocProvider<AccountBloc>.value(value: accountBloc!)
        else
          BlocProvider<AccountBloc>(
            create: (_) =>
                SettingsDependencies.createAccountBloc()
                  ..add(const LoadAccountEvent()),
          ),
      ],
      child: const _DeckCompilationView(),
    );
  }
}

class _DeckCompilationView extends StatefulWidget {
  const _DeckCompilationView();

  @override
  State<_DeckCompilationView> createState() => _DeckCompilationViewState();
}

class _DeckCompilationViewState extends State<_DeckCompilationView> {
  final TextEditingController _searchController = TextEditingController();
  RouterDelegate<Object>? _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final delegate = GoRouter.maybeOf(context)?.routerDelegate;
    if (_routerDelegate != delegate) {
      _routerDelegate?.removeListener(_onRouteChanged);
      _routerDelegate = delegate;
      _routerDelegate?.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    if (!mounted) return;
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    final location = router.routeInformationProvider.value.uri.path;
    if (location == AppRoutes.deck) {
      context.read<DeckBloc>().add(const LoadDecksEvent());
    }
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDeckModal(BuildContext context) {
    final deckBloc = context.read<DeckBloc>();
    AddDeckMethodModal.show(
      context,
      onSelectGenerate: () async {
        await context.push(AppRoutes.deckGenerate);
        if (mounted) {
          deckBloc.add(const LoadDecksEvent());
        }
      },
      onSelectImport: () async {
        await context.push(AppRoutes.deckImport);
        if (mounted) {
          deckBloc.add(const LoadDecksEvent());
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String currentUsername,
  ) {
    final deckBloc = context.read<DeckBloc>();
    showDialog<void>(
      context: context,
      barrierColor: Colors.black38,
      builder: (dialogCtx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: DeleteDecksDialog(
          expectedUsername: currentUsername,
          onCancel: () => Navigator.of(dialogCtx).pop(),
          onConfirm: (verifiedUsername) {
            Navigator.of(dialogCtx).pop();
            deckBloc.add(
              ConfirmDeleteSelectedDecksEvent(
                verificationUsername: verifiedUsername,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    final genBloc = context.read<GenerateDeckBloc?>();

    Widget body = BlocConsumer<DeckBloc, DeckState>(
      listener: (context, state) {
        if (state is DeckLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final isSelectionMode = state is DeckLoaded && state.isSelectionMode;

        return PopScope(
          canPop: !isSelectionMode,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && isSelectionMode) {
              context.read<DeckBloc>().add(
                const CancelDeckSelectionModeEvent(),
              );
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Title
                        Text(
                          l.deck_compilation_title,
                          textAlign: TextAlign.center,
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Search Bar
                        DeckSearchBar(
                          controller: _searchController,
                          onChanged: (val) => context.read<DeckBloc>().add(
                            SearchDecksChangedEvent(val),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Select All / Deselect All bar in selection mode
                        if (isSelectionMode) ...[
                          DeckSelectionHeaderBar(
                            isAllSelected: state.isAllSelected,
                            onSelectAll: () => context.read<DeckBloc>().add(
                              const SelectAllDecksEvent(),
                            ),
                            onDeselectAll: () => context.read<DeckBloc>().add(
                              const DeselectAllDecksEvent(),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ] else
                          const SizedBox(height: 12),

                        // Body Content
                        Expanded(
                          child: _DeckBodyContent(
                            state: state,
                            onAddDeck: () => _openAddDeckModal(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Add Button (default mode)
                  if (!isSelectionMode)
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: DeckAddFab(
                        onPressed: () => _openAddDeckModal(context),
                      ),
                    ),

                  // Floating Selection Action Bar (selection mode)
                  if (isSelectionMode)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 16,
                      child: BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, accountState) {
                          var currentUsername = 'Rizky_23';
                          if (accountState is AccountLoaded &&
                              accountState.profile.username.trim().isNotEmpty) {
                            currentUsername = accountState.profile.username
                                .trim();
                          }

                          return DeckSelectionBottomBar(
                            selectedCount: state.selectedCount,
                            onCancel: () => context.read<DeckBloc>().add(
                              const CancelDeckSelectionModeEvent(),
                            ),
                            onDelete: () => _showDeleteConfirmationDialog(
                              context,
                              currentUsername,
                            ),
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

    if (genBloc != null) {
      body = BlocListener<GenerateDeckBloc, GenerateDeckState>(
        listener: (context, genState) {
          if (genState is GenerateDeckSuccessState) {
            context.read<DeckBloc>().add(const LoadDecksEvent());
          }
        },
        child: body,
      );
    }

    return body;
  }
}

class _DeckBodyContent extends StatelessWidget {
  final DeckState state;
  final VoidCallback onAddDeck;

  const _DeckBodyContent({required this.state, required this.onAddDeck});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    final genBlocState = context.watch<GenerateDeckBloc?>()?.state;
    final genInProgress =
        genBlocState is GenerateDeckInProgressState ? genBlocState : null;

    return switch (state) {
      DeckInitial() ||
      DeckLoading() => const Center(child: CircularProgressIndicator()),
      DeckError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () =>
                  context.read<DeckBloc>().add(const LoadDecksEvent()),
              child: Text(l.tryAgain),
            ),
          ],
        ),
      ),
      DeckLoaded(
        :final allDecks,
        :final filteredDecks,
        :final isSelectionMode,
        :final selectedDeckIds,
      ) =>
        (() {
          if (allDecks.isEmpty && genInProgress == null) {
            return Center(child: HomeEmptyState(onCreateDeck: onAddDeck));
          }

          if (filteredDecks.isEmpty && genInProgress == null) {
            return Center(
              child: Text(
                l.deck_empty_search_title,
                style: t.titleMedium?.copyWith(color: c.onSurfaceVariant),
              ),
            );
          }

          final itemCount =
              filteredDecks.length + (genInProgress != null ? 1 : 0);

          return GridView.builder(
            padding: EdgeInsets.only(bottom: isSelectionMode ? 96 : 88),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.78,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (genInProgress != null && index == 0) {
                return GeneratingDeckPlaceholderCard(
                  progressState: genInProgress,
                );
              }

              final deckIndex = genInProgress != null ? index - 1 : index;
              final deck = filteredDecks[deckIndex];
              final isSelected = selectedDeckIds.contains(deck.id);

              return DeckCard(
                key: ValueKey(deck.id),
                deck: deck,
                isSelectionMode: isSelectionMode,
                isSelected: isSelected,
                onTap: () async {
                  if (isSelectionMode) {
                    context.read<DeckBloc>().add(
                      ToggleDeckSelectionEvent(deck.id),
                    );
                  } else {
                    final deckBloc = context.read<DeckBloc>();
                    await context.push(AppRoutes.deckDetailsPath(deck.id));
                    if (context.mounted) {
                      deckBloc.add(const LoadDecksEvent());
                    }
                  }
                },
                onLongPress: () {
                  if (!isSelectionMode) {
                    context.read<DeckBloc>().add(
                      EnterDeckSelectionModeEvent(deck.id),
                    );
                  } else {
                    context.read<DeckBloc>().add(
                      ToggleDeckSelectionEvent(deck.id),
                    );
                  }
                },
              );
            },
          );
        })(),
    };
  }
}
