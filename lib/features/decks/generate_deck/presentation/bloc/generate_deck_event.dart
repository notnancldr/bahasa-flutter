import 'package:flutter/foundation.dart';

@immutable
sealed class GenerateDeckEvent {
  const GenerateDeckEvent();
}

class DeckNameChanged extends GenerateDeckEvent {
  final String name;
  const DeckNameChanged(this.name);
}

class DeckCountryChanged extends GenerateDeckEvent {
  final String languageCode;
  const DeckCountryChanged(this.languageCode);
}

class DeckDifficultyChanged extends GenerateDeckEvent {
  final String difficulty;
  const DeckDifficultyChanged(this.difficulty);
}

class DeckDescriptionChanged extends GenerateDeckEvent {
  final String description;
  const DeckDescriptionChanged(this.description);
}

class NextStepRequested extends GenerateDeckEvent {
  const NextStepRequested();
}

class PreviousStepRequested extends GenerateDeckEvent {
  const PreviousStepRequested();
}

class JumpToStepRequested extends GenerateDeckEvent {
  final int stepIndex;
  const JumpToStepRequested(this.stepIndex);
}

class SubmitGenerationRequested extends GenerateDeckEvent {
  const SubmitGenerationRequested();
}

class ConfirmGenerationCompleted extends GenerateDeckEvent {
  const ConfirmGenerationCompleted();
}
