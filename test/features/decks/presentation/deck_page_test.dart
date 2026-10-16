import 'dart:ui' as ui;

import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/features/decks/domain/entities/deck_item.dart';
import 'package:bahasa/features/decks/domain/repositories/deck_repository.dart';
import 'package:bahasa/features/decks/domain/usecases/delete_decks_usecase.dart';
import 'package:bahasa/features/decks/domain/usecases/get_decks_usecase.dart';
import 'package:bahasa/features/decks/presentation/bloc/deck_bloc.dart';
import 'package:bahasa/features/decks/presentation/bloc/deck_event.dart';
import 'package:bahasa/features/decks/presentation/pages/deck_page.dart';
import 'package:bahasa/features/decks/presentation/utils/flag_palette_color_cache.dart';
import 'package:bahasa/features/decks/presentation/widgets/deck_add_fab.dart';
import 'package:bahasa/features/decks/presentation/widgets/deck_card.dart';
import 'package:bahasa/features/decks/presentation/widgets/deck_selection_bottom_bar.dart';
import 'package:bahasa/features/decks/presentation/widgets/delete_decks_dialog.dart';
import 'package:bahasa/features/settings/domain/entities/user_profile.dart';
import 'package:bahasa/features/settings/domain/repositories/profile_repository.dart';
import 'package:bahasa/features/settings/domain/usecases/delete_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/pick_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/set_default_language_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_profile_photo_usecase.dart';
import 'package:bahasa/features/settings/domain/usecases/update_username_usecase.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDeckRepository implements DeckRepository {
  final List<DeckItem> decks;

  _FakeDeckRepository(this.decks);

  @override
  Future<List<DeckItem>> getDecks() async => List<DeckItem>.from(decks);

  @override
  Future<void> deleteDecks({
    required List<String> deckIds,
    required String verificationUsername,
  }) async {
    decks.removeWhere((d) => deckIds.contains(d.id));
  }
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile> getProfile() async {
    return const UserProfile(username: 'Rizky_23', defaultLanguage: 'id');
  }

  @override
  Future<UserProfile> saveProfile(UserProfile profile) async => profile;

  @override
  Future<UserProfile> updateUsername(String newUsername) async {
    return UserProfile(username: newUsername, defaultLanguage: 'id');
  }

  @override
  Future<UserProfile> updateDefaultLanguage(String newDefaultLanguage) async {
    return UserProfile(
      username: 'Rizky_23',
      defaultLanguage: newDefaultLanguage,
    );
  }

  @override
  Future<UserProfile> updateProfilePhoto(String photoPath) async {
    return UserProfile(
      username: 'Rizky_23',
      defaultLanguage: 'id',
      photoPath: photoPath,
    );
  }

  @override
  Future<String?> pickProfilePhoto() async => null;

  @override
  Future<void> deleteProfileAndData() async {}
}

void main() {
  late List<DeckItem> sampleDecks;
  setUp(() {
    FlagPaletteColorCache.clearCache();
    // Pre-seed cache to avoid pending timer retries inside widget tests
    FlagPaletteColorCache.setCachedColor(
      'ja',
      ColorScheme.fromSeed(seedColor: const Color(0xFFBC002D)).primary,
    );

    sampleDecks = [
      const DeckItem(
        id: 'd1',
        name: 'Kosakata Bahasa Jepang',
        language: 'ja',
        difficulty: 'beginner',
        activeTime: 0,
        createdAt: 1000,
        updatedAt: 1000,
      ),
      const DeckItem(
        id: 'd2',
        name: 'Percakapan Bahasa Jepang',
        language: 'ja',
        difficulty: 'intermediate',
        activeTime: 0,
        createdAt: 2000,
        updatedAt: 2000,
      ),
    ];
  });

  Widget buildTestApp(DeckBloc deckBloc, AccountBloc accountBloc) {
    return MaterialApp(
      locale: const Locale('id'),
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DeckPage(bloc: deckBloc, accountBloc: accountBloc),
    );
  }

  test('FlagPaletteColorCache extracts dominant color from flag image and seeds ColorScheme primary', () async {
    FlagPaletteColorCache.clearCache();

    // Synthesize a 40x30 Japanese flag image (white background with red circle)
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 40, 30),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      const Offset(20, 15),
      10,
      Paint()..color = const Color(0xFFBC002D),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(40, 30);

    try {
      final primaryColor =
          await FlagPaletteColorCache.extractPrimaryColorFromImage(
            image,
            languageCode: 'ja',
          );

      expect(primaryColor, isNotNull);
      expect(FlagPaletteColorCache.getCachedColor('ja'), equals(primaryColor));
    } finally {
      image.dispose();
      picture.dispose();
    }
  });

  testWidgets(
    'DeckPage renders default state, transitions to selection mode, selects all, and deletes with username confirmation',
    (tester) async {
      final deckRepo = _FakeDeckRepository(sampleDecks);
      final deckBloc = DeckBloc(
        getDecksUseCase: GetDecksUseCase(deckRepo),
        deleteDecksUseCase: DeleteDecksUseCase(deckRepo),
      )..add(const LoadDecksEvent());

      final profileRepo = _FakeProfileRepository();
      final accountBloc = AccountBloc(
        getProfileUseCase: GetProfileUseCase(profileRepo),
        updateUsernameUseCase: UpdateUsernameUseCase(profileRepo),
        updateProfilePhotoUseCase: UpdateProfilePhotoUseCase(profileRepo),
        pickProfilePhotoUseCase: PickProfilePhotoUseCase(profileRepo),
        deleteProfileUseCase: DeleteProfileUseCase(profileRepo),
        setDefaultLanguageUsecase: SetDefaultLanguageUsecase(profileRepo),
      )..add(const LoadAccountEvent());

      addTearDown(() async {
        await deckBloc.close();
        await accountBloc.close();
      });

      await tester.pumpWidget(buildTestApp(deckBloc, accountBloc));
      await tester.pumpAndSettle();

      // 1. Default state (DeckCompilation.png)
      expect(find.text('Kompilasi Deck'), findsOneWidget);
      expect(find.text('Cari deck anda...'), findsOneWidget);
      expect(find.byType(DeckCard), findsNWidgets(2));
      expect(find.byType(DeckAddFab), findsOneWidget);
      expect(find.byType(DeckSelectionBottomBar), findsNothing);

      // 2. Long-press first card to enter selection mode (DeckCompilation-1.png)
      await tester.longPress(find.byType(DeckCard).first);
      await tester.pumpAndSettle();

      expect(find.text('Pilih semua'), findsOneWidget);
      expect(find.text('1 deck terpilih'), findsOneWidget);
      expect(find.byType(DeckSelectionBottomBar), findsOneWidget);
      expect(find.byType(DeckAddFab), findsNothing);

      // 3. Tap "Pilih semua" to select all cards (DeckCompilation-2.png)
      await tester.tap(find.text('Pilih semua'));
      await tester.pumpAndSettle();

      expect(find.text('Batal pilih semua'), findsOneWidget);
      expect(find.text('2 deck terpilih'), findsOneWidget);

      // 4. Tap "Hapus" to open DeleteDecksDialog (DeckCompilation-3.png)
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDecksDialog), findsOneWidget);
      expect(find.text('Hapus Deck Ini??'), findsOneWidget);

      // Type matching username "Rizky_23" into confirmation dialog
      final dialogTextField = find.descendant(
        of: find.byType(DeleteDecksDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(dialogTextField, 'Rizky_23');
      await tester.pumpAndSettle();

      // Tap "Hapus Data" button
      await tester.tap(find.text('Hapus Data'));
      await tester.pumpAndSettle();

      // Verify all selected decks were deleted and empty state is shown
      expect(find.byType(DeckCard), findsNothing);
      expect(find.text('Kamu belum punya deck!'), findsOneWidget);
    },
  );
}
