abstract class AppRoutes {
  static const home = "/";
  static const multiplayer = "/multiplayer";
  static const multiplayerRoom = "/multiplayer/room";
  static const multiplayerLobby = "/multiplayer/lobby";
  static const multiplayerSelectDeck = "/multiplayer/select-deck";
  static const multiplayerGame = "/multiplayer/game";
  static const multiplayerComplete = "/multiplayer/complete";
  static const multiplayerHistory = "/multiplayer/history";
  static const deck = "/deck";
  static const deckGenerate = "/deck/generate";
  static const deckImport = "/deck/import";
  static const deckDetails = "/deck/details/:deckId";
  static const deckStreak = "/deck/details/:deckId/streak";
  static const deckAccuracy = "/deck/details/:deckId/accuracy";
  static const deckFlashcard = "/deck/details/:deckId/flashcard";
  static const deckQuiz = "/deck/details/:deckId/quiz";
  static const deckHistory = "/deck/history";
  static const deckDetailsHistory = "/deck/details/:deckId/history";
  static const login = "/login";

  static const loginTransfer = "/login/transfer";
  static const loginNew = "/login/new";

  // Settings
  static const settings = "/settings";
  static const settingsAccount = "/settings/account";
  static const settingsAccountEdit = "/settings/account/edit";
  static const settingsTheme = "/settings/theme";
  static const settingsLanguage = "/settings/language";
  static const settingsDataStorage = "/settings/data";
  static const settingsDataTransfer = "/settings/data/transfer";

  /// Builds the concrete path for [deckDetails].
  static String deckDetailsPath(String deckId) => "/deck/details/$deckId";

  /// Builds the concrete path for [deckStreak].
  static String deckStreakPath(String deckId) => "/deck/details/$deckId/streak";

  /// Builds the concrete path for [deckAccuracy].
  static String deckAccuracyPath(String deckId) =>
      "/deck/details/$deckId/accuracy";

  /// Builds the concrete path for [deckFlashcard].
  static String deckFlashcardPath(String deckId) =>
      "/deck/details/$deckId/flashcard";

  /// Builds the concrete path for [deckQuiz].
  static String deckQuizPath(String deckId) => "/deck/details/$deckId/quiz";

  /// Builds the concrete path for [deckHistory] or [deckDetailsHistory].
  static String deckHistoryPath([String? deckId]) =>
      deckId != null ? "/deck/details/$deckId/history" : "/deck/history";
}
