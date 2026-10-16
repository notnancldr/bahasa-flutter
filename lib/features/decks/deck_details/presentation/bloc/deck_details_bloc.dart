import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/deck_card_item.dart';
import '../../domain/usecases/get_deck_details_usecase.dart';
import 'deck_details_event.dart';
import 'deck_details_state.dart';

/// BLoC managing the Deck Details (Activity) page state, including loading
/// deck metadata, cards, streak/accuracy metrics, and real-time card search.
class DeckDetailsBloc extends Bloc<DeckDetailsEvent, DeckDetailsState> {
  /// Use case for loading Deck Details data.
  final GetDeckDetailsUseCase getDeckDetailsUseCase;

  /// Creates a [DeckDetailsBloc].
  DeckDetailsBloc({required this.getDeckDetailsUseCase})
    : super(const DeckDetailsInitial()) {
    on<LoadDeckDetailsEvent>(_onLoadDeckDetails);
    on<SearchDeckCardsChangedEvent>(_onSearchDeckCardsChanged);
  }

  Future<void> _onLoadDeckDetails(
    LoadDeckDetailsEvent event,
    Emitter<DeckDetailsState> emit,
  ) async {
    final currentQuery = state is DeckDetailsLoaded
        ? (state as DeckDetailsLoaded).searchQuery
        : '';
    if (state is! DeckDetailsLoaded) {
      emit(const DeckDetailsLoading());
    }

    try {
      final data = await getDeckDetailsUseCase(event.deckId);
      final filtered = _filterCards(data.cards, currentQuery);
      emit(
        DeckDetailsLoaded(
          data: data,
          searchQuery: currentQuery,
          filteredCards: filtered,
        ),
      );
    } catch (e) {
      emit(DeckDetailsError(e.toString()));
    }
  }

  void _onSearchDeckCardsChanged(
    SearchDeckCardsChangedEvent event,
    Emitter<DeckDetailsState> emit,
  ) {
    final current = state;
    if (current is! DeckDetailsLoaded) return;

    final filtered = _filterCards(current.data.cards, event.query);
    emit(current.copyWith(searchQuery: event.query, filteredCards: filtered));
  }

  List<DeckCardItem> _filterCards(List<DeckCardItem> allCards, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return allCards;

    return allCards.where((card) {
      return card.translation.toLowerCase().contains(normalized) ||
          card.defaultLanguage.toLowerCase().contains(normalized) ||
          card.phoneticLang.toLowerCase().contains(normalized);
    }).toList();
  }
}
