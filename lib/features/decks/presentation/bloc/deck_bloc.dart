import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/deck_item.dart';
import '../../domain/usecases/delete_decks_usecase.dart';
import '../../domain/usecases/get_decks_usecase.dart';
import 'deck_event.dart';
import 'deck_state.dart';

/// BLoC managing the Deck Compilation page state, including deck loading,
/// search filtering, multi-selection mode, and username-confirmed deletion.
class DeckBloc extends Bloc<DeckEvent, DeckState> {
  final GetDecksUseCase _getDecksUseCase;
  final DeleteDecksUseCase _deleteDecksUseCase;

  /// Creates a [DeckBloc] wired to [_getDecksUseCase] and [_deleteDecksUseCase].
  DeckBloc({required this._getDecksUseCase, required this._deleteDecksUseCase})
    : super(const DeckInitial()) {
    on<LoadDecksEvent>(_onLoadDecks);
    on<SearchDecksChangedEvent>(_onSearchDecksChanged);
    on<EnterDeckSelectionModeEvent>(_onEnterSelectionMode);
    on<ToggleDeckSelectionEvent>(_onToggleDeckSelection);
    on<SelectAllDecksEvent>(_onSelectAllDecks);
    on<DeselectAllDecksEvent>(_onDeselectAllDecks);
    on<CancelDeckSelectionModeEvent>(_onCancelSelectionMode);
    on<ConfirmDeleteSelectedDecksEvent>(_onConfirmDeleteSelectedDecks);
  }

  List<DeckItem> _applySearch(List<DeckItem> decks, String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return decks;
    return decks
        .where((deck) => deck.name.toLowerCase().contains(trimmed))
        .toList();
  }

  Future<void> _onLoadDecks(
    LoadDecksEvent event,
    Emitter<DeckState> emit,
  ) async {
    final currentState = state;
    final previousQuery = currentState is DeckLoaded
        ? currentState.searchQuery
        : '';

    if (currentState is! DeckLoaded) {
      emit(const DeckLoading());
    }

    try {
      final allDecks = await _getDecksUseCase();
      final filteredDecks = _applySearch(allDecks, previousQuery);
      emit(
        DeckLoaded(
          allDecks: allDecks,
          filteredDecks: filteredDecks,
          searchQuery: previousQuery,
        ),
      );
    } catch (e) {
      emit(DeckError(e.toString()));
    }
  }

  void _onSearchDecksChanged(
    SearchDecksChangedEvent event,
    Emitter<DeckState> emit,
  ) {
    final currentState = state;
    if (currentState is! DeckLoaded) return;

    final filtered = _applySearch(currentState.allDecks, event.query);
    emit(
      currentState.copyWith(
        searchQuery: event.query,
        filteredDecks: filtered,
        clearError: true,
      ),
    );
  }

  void _onEnterSelectionMode(
    EnterDeckSelectionModeEvent event,
    Emitter<DeckState> emit,
  ) {
    final currentState = state;
    if (currentState is! DeckLoaded) return;

    emit(
      currentState.copyWith(
        isSelectionMode: true,
        selectedDeckIds: {event.initialDeckId},
        clearError: true,
      ),
    );
  }

  void _onToggleDeckSelection(
    ToggleDeckSelectionEvent event,
    Emitter<DeckState> emit,
  ) {
    final currentState = state;
    if (currentState is! DeckLoaded || !currentState.isSelectionMode) return;

    final updated = Set<String>.from(currentState.selectedDeckIds);
    if (updated.contains(event.deckId)) {
      updated.remove(event.deckId);
    } else {
      updated.add(event.deckId);
    }

    emit(currentState.copyWith(selectedDeckIds: updated, clearError: true));
  }

  void _onSelectAllDecks(SelectAllDecksEvent event, Emitter<DeckState> emit) {
    final currentState = state;
    if (currentState is! DeckLoaded || !currentState.isSelectionMode) return;

    final updated = Set<String>.from(currentState.selectedDeckIds)
      ..addAll(currentState.filteredDecks.map((d) => d.id));

    emit(currentState.copyWith(selectedDeckIds: updated, clearError: true));
  }

  void _onDeselectAllDecks(
    DeselectAllDecksEvent event,
    Emitter<DeckState> emit,
  ) {
    final currentState = state;
    if (currentState is! DeckLoaded || !currentState.isSelectionMode) return;

    emit(
      currentState.copyWith(
        selectedDeckIds: const <String>{},
        clearError: true,
      ),
    );
  }

  void _onCancelSelectionMode(
    CancelDeckSelectionModeEvent event,
    Emitter<DeckState> emit,
  ) {
    final currentState = state;
    if (currentState is! DeckLoaded) return;

    emit(
      currentState.copyWith(
        isSelectionMode: false,
        selectedDeckIds: const <String>{},
        clearError: true,
      ),
    );
  }

  Future<void> _onConfirmDeleteSelectedDecks(
    ConfirmDeleteSelectedDecksEvent event,
    Emitter<DeckState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DeckLoaded) return;

    final targetIds = currentState.selectedDeckIds.toList();
    if (targetIds.isEmpty) return;

    try {
      await _deleteDecksUseCase(
        deckIds: targetIds,
        verificationUsername: event.verificationUsername,
      );

      final allDecks = await _getDecksUseCase();
      final filteredDecks = _applySearch(allDecks, currentState.searchQuery);
      emit(
        DeckLoaded(
          allDecks: allDecks,
          filteredDecks: filteredDecks,
          searchQuery: currentState.searchQuery,
          isSelectionMode: false,
          selectedDeckIds: const <String>{},
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(errorMessage: e.toString()));
    }
  }
}
