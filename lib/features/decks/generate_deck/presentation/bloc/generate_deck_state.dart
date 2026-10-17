import 'package:flutter/foundation.dart';

import '../../domain/entities/deck_generation_request.dart';
import '../../domain/entities/generated_deck_result.dart';

@immutable
sealed class GenerateDeckState {
  const GenerateDeckState();
}

/// Wizard step state collecting user configuration.
class GenerateDeckWizardState extends GenerateDeckState {
  /// Current step index:
  /// 0 = Name, 1 = Country, 2 = Difficulty, 3 = Description, 4 = Review
  final int step;

  final String name;
  final String language;
  final String difficulty;
  final String description;

  const GenerateDeckWizardState({
    this.step = 0,
    this.name = '',
    this.language = '',
    this.difficulty = 'intermediate',
    this.description = '',
  });

  bool get isNameValid => name.trim().isNotEmpty;
  bool get isLanguageValid => language.trim().isNotEmpty;
  bool get isDifficultyValid => difficulty.trim().isNotEmpty;

  bool get canProceedToNext {
    return switch (step) {
      0 => isNameValid,
      1 => isLanguageValid,
      2 => isDifficultyValid,
      3 => true,
      _ => true,
    };
  }

  DeckGenerationRequest toRequest() {
    return DeckGenerationRequest(
      name: name,
      language: language,
      difficulty: difficulty,
      description: description,
    );
  }

  GenerateDeckWizardState copyWith({
    int? step,
    String? name,
    String? language,
    String? difficulty,
    String? description,
  }) {
    return GenerateDeckWizardState(
      step: step ?? this.step,
      name: name ?? this.name,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
    );
  }
}

/// In-progress state while AI generation is executing.
class GenerateDeckInProgressState extends GenerateDeckState {
  final String deckName;
  final String language;
  final int collectedCards;
  final int totalCards;
  final bool isLocalAi;

  const GenerateDeckInProgressState({
    required this.deckName,
    required this.language,
    this.collectedCards = 0,
    this.totalCards = 20,
    this.isLocalAi = false,
  });

  GenerateDeckInProgressState copyWith({
    int? collectedCards,
    int? totalCards,
  }) {
    return GenerateDeckInProgressState(
      deckName: deckName,
      language: language,
      collectedCards: collectedCards ?? this.collectedCards,
      totalCards: totalCards ?? this.totalCards,
      isLocalAi: isLocalAi,
    );
  }
}

/// Error state when generation fails.
class GenerateDeckErrorState extends GenerateDeckState {
  final String errorMessage;

  const GenerateDeckErrorState(this.errorMessage);
}

/// Success state after generation finishes.
class GenerateDeckSuccessState extends GenerateDeckState {
  final GeneratedDeckResult result;

  const GenerateDeckSuccessState(this.result);
}
