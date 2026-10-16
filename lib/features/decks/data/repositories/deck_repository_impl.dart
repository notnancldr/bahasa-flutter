import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/datasources/profile_local_data_source.dart';

import '../../domain/entities/deck_item.dart';
import '../../domain/repositories/deck_repository.dart';
import '../datasources/deck_local_data_source.dart';

/// Implementation of [DeckRepository] coordinating deck queries, username verification,
/// and permanent deck deletion.
class DeckRepositoryImpl implements DeckRepository {
  final DeckLocalDataSource _localDataSource;
  final ProfileLocalDataSource _profileDataSource;

  /// Creates a [DeckRepositoryImpl] with required data sources.
  const DeckRepositoryImpl({
    required this._localDataSource,
    required this._profileDataSource,
  });

  @override
  Future<List<DeckItem>> getDecks() {
    return _localDataSource.getDecks();
  }

  @override
  Future<void> deleteDecks({
    required List<String> deckIds,
    required String verificationUsername,
  }) async {
    final profile = await _profileDataSource.getProfile();
    final expectedUsername = profile.username.trim().isNotEmpty
        ? profile.username.trim()
        : 'Rizky_23';

    if (verificationUsername.trim() != expectedUsername) {
      throw const UsernameMismatchFailure(
        'The entered username does not match your current username.',
      );
    }

    await _localDataSource.deleteDecks(deckIds);
  }
}
