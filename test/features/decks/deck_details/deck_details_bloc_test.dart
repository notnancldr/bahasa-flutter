import 'package:bahasa/features/decks/deck_details/domain/entities/deck_card_item.dart';
import 'package:bahasa/features/decks/deck_details/domain/entities/deck_details_data.dart';
import 'package:bahasa/features/decks/deck_details/domain/entities/deck_progress_data.dart';
import 'package:bahasa/features/decks/deck_details/domain/repositories/deck_details_repository.dart';
import 'package:bahasa/features/decks/deck_details/domain/usecases/get_deck_details_usecase.dart';
import 'package:bahasa/features/decks/deck_details/presentation/bloc/deck_details_bloc.dart';
import 'package:bahasa/features/decks/deck_details/presentation/bloc/deck_details_event.dart';
import 'package:bahasa/features/decks/deck_details/presentation/bloc/deck_details_state.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDeckDetailsRepository implements DeckDetailsRepository {
  @override
  Future<DeckDetailsData> getDeckDetails(String deckId) async {
    return DeckDetailsData(
      deck: DeckItem(
        id: deckId,
        name: 'Kosakata Bahasa Jepang',
        language: 'ja',
        difficulty: 'intermediate',
        activeTime: 60000,
        createdAt: 1000,
        updatedAt: 1000,
      ),
      cards: const [
        DeckCardItem(
          idCard: 'c1',
          defaultLanguage: 'Halo',
          translation: 'Konnichiwa',
          phoneticLang: '/kon.ni.tɕi.wa/',
          additionalContext: 'Sapaan umum',
          reps: 2,
          correctAnswer: 2,
          finalScore: 100,
        ),
        DeckCardItem(
          idCard: 'c2',
          defaultLanguage: 'Selamat tinggal',
          translation: 'Sayounara',
          phoneticLang: '/sa.joː.na.ɾa/',
          additionalContext: 'Salam perpisahan',
          reps: 2,
          correctAnswer: 1,
          finalScore: 50,
        ),
      ],
      streakCount: 5,
      accuracyPercent: 75,
    );
  }

  @override
  Future<DeckProgressData> getDeckProgress(
    String deckId, {
    DateTime? referenceDate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<WeakCardSummary>> getWeakestCardsForRange(
    String deckId, {
    required int startEpochMs,
    required int endEpochMs,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test(
    'DeckDetailsBloc loads deck details and filters cards by query',
    () async {
      final bloc = DeckDetailsBloc(
        getDeckDetailsUseCase: GetDeckDetailsUseCase(
          _FakeDeckDetailsRepository(),
        ),
      );

      bloc.add(const LoadDeckDetailsEvent('d1'));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<DeckDetailsLoaded>());
      var loaded = bloc.state as DeckDetailsLoaded;
      expect(loaded.filteredCards.length, equals(2));
      expect(loaded.data.streakCount, equals(5));
      expect(loaded.data.accuracyPercent, equals(75));

      bloc.add(const SearchDeckCardsChangedEvent('sayou'));
      await Future<void>.delayed(Duration.zero);

      loaded = bloc.state as DeckDetailsLoaded;
      expect(loaded.filteredCards.length, equals(1));
      expect(loaded.filteredCards.first.translation, equals('Sayounara'));

      await bloc.close();
    },
  );
}
