import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:bahasa/features/decks/domain/repositories/deck_repository.dart';
import 'package:bahasa/features/decks/domain/usecases/delete_decks_usecase.dart';
import 'package:bahasa/features/decks/domain/usecases/get_decks_usecase.dart';
import 'package:bahasa/features/decks/presentation/bloc/deck_bloc.dart';
import 'package:bahasa/features/decks/presentation/bloc/deck_event.dart';
import 'package:bahasa/features/decks/presentation/bloc/deck_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryDeckRepository implements DeckRepository {
  final List<DeckItem> decks;
  static const String _expectedUsername = 'Rizky_23';

  _InMemoryDeckRepository({required this.decks});

  @override
  Future<List<DeckItem>> getDecks() async => List<DeckItem>.from(decks);

  @override
  Future<void> deleteDecks({
    required List<String> deckIds,
    required String verificationUsername,
  }) async {
    if (verificationUsername.trim() != _expectedUsername) {
      throw Exception('Username mismatch');
    }
    decks.removeWhere((d) => deckIds.contains(d.id));
  }
}

void main() {
  late _InMemoryDeckRepository repository;
  late DeckBloc bloc;

  final sampleDecks = [
    const DeckItem(
      id: '1',
      name: 'Kosakata Bahasa Jepang',
      language: 'ja',
      difficulty: 'beginner',
      activeTime: 0,
      createdAt: 1000,
      updatedAt: 1000,
    ),
    const DeckItem(
      id: '2',
      name: 'Kosakata Bahasa Inggris',
      language: 'en',
      difficulty: 'intermediate',
      activeTime: 0,
      createdAt: 2000,
      updatedAt: 2000,
    ),
  ];

  setUp(() {
    repository = _InMemoryDeckRepository(
      decks: List<DeckItem>.from(sampleDecks),
    );
    bloc = DeckBloc(
      getDecksUseCase: GetDecksUseCase(repository),
      deleteDecksUseCase: DeleteDecksUseCase(repository),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test('LoadDecksEvent loads all decks into DeckLoaded state', () async {
    bloc.add(const LoadDecksEvent());
    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<DeckLoading>(),
        isA<DeckLoaded>()
            .having((s) => s.allDecks.length, 'allDecks length', 2)
            .having((s) => s.isSelectionMode, 'isSelectionMode', isFalse),
      ]),
    );
  });

  test('SearchDecksChangedEvent filters decks by name', () async {
    bloc.add(const LoadDecksEvent());
    await bloc.stream.firstWhere((s) => s is DeckLoaded);

    bloc.add(const SearchDecksChangedEvent('Jepang'));
    final state = await bloc.stream.first as DeckLoaded;

    expect(state.filteredDecks, hasLength(1));
    expect(state.filteredDecks.first.id, '1');
  });

  test('Selection mode transitions: enter, toggle, select all, deselect all, cancel', () async {
    bloc.add(const LoadDecksEvent());
    await bloc.stream.firstWhere((s) => s is DeckLoaded);

    // Enter selection mode with deck '1'
    bloc.add(const EnterDeckSelectionModeEvent('1'));
    var state = await bloc.stream.first as DeckLoaded;
    expect(state.isSelectionMode, isTrue);
    expect(state.selectedDeckIds, {'1'});
    expect(state.isAllSelected, isFalse);

    // Select all
    bloc.add(const SelectAllDecksEvent());
    state = await bloc.stream.first as DeckLoaded;
    expect(state.selectedDeckIds, {'1', '2'});
    expect(state.isAllSelected, isTrue);

    // Deselect all
    bloc.add(const DeselectAllDecksEvent());
    state = await bloc.stream.first as DeckLoaded;
    expect(state.selectedDeckIds, isEmpty);
    expect(state.isSelectionMode, isTrue);

    // Toggle '2' on
    bloc.add(const ToggleDeckSelectionEvent('2'));
    state = await bloc.stream.first as DeckLoaded;
    expect(state.selectedDeckIds, {'2'});

    // Cancel selection mode
    bloc.add(const CancelDeckSelectionModeEvent());
    state = await bloc.stream.first as DeckLoaded;
    expect(state.isSelectionMode, isFalse);
    expect(state.selectedDeckIds, isEmpty);
  });

  test('ConfirmDeleteSelectedDecksEvent deletes selected decks and exits selection mode', () async {
    bloc.add(const LoadDecksEvent());
    await bloc.stream.firstWhere((s) => s is DeckLoaded);

    bloc.add(const EnterDeckSelectionModeEvent('1'));
    await bloc.stream.first;

    bloc.add(
      const ConfirmDeleteSelectedDecksEvent(verificationUsername: 'Rizky_23'),
    );
    final state = await bloc.stream.first as DeckLoaded;

    expect(state.isSelectionMode, isFalse);
    expect(state.selectedDeckIds, isEmpty);
    expect(state.allDecks.map((d) => d.id).toList(), ['2']);
  });
}
