import '../../domain/entities/deck_progress_data.dart';

/// View tab selection on the Deck Progress page (`Bulan` bar chart vs `Tahun` calendar).
enum DeckProgressPeriodTab {
  /// Monthly bar chart view (`Bulan`).
  month,

  /// Calendar heatmap view (`Tahun`).
  year,
}

/// Details of a tapped day or month period for the Period Detail bottom sheet.
class SelectedPeriodDetail {
  /// Badge number displayed inside the starburst icon (e.g., day `23` or month `10`).
  final int badgeNumber;

  /// Formatted period title (e.g., `"Rabu, 23 Oktober 2026"` or `"Oktober 2026"`).
  final DateTime date;

  /// Whether the selection represents an entire month (`true`) or a single day (`false`).
  final bool isMonth;

  /// Number of cards practiced during this period.
  final int cardsPracticed;

  /// Accuracy percentage (0..100) during this period.
  final int accuracyPercent;

  /// Active study time in minutes during this period.
  final int activeMinutes;

  /// Top 3 weakest cards during this period.
  final List<WeakCardSummary> weakestCards;

  /// Creates a [SelectedPeriodDetail].
  const SelectedPeriodDetail({
    required this.badgeNumber,
    required this.date,
    required this.isMonth,
    required this.cardsPracticed,
    required this.accuracyPercent,
    required this.activeMinutes,
    required this.weakestCards,
  });
}

/// State definitions for [DeckProgressCubit].
sealed class DeckProgressState {
  /// Base constructor for [DeckProgressState].
  const DeckProgressState();
}

/// Loading state while progress data is being queried.
final class DeckProgressLoading extends DeckProgressState {
  /// Creates a [DeckProgressLoading].
  const DeckProgressLoading();
}

/// Loaded state containing deck progress data and current UI selections.
final class DeckProgressLoaded extends DeckProgressState {
  /// Complete deck progress data.
  final DeckProgressData progress;

  /// Active period tab (`Bulan` vs `Tahun`).
  final DeckProgressPeriodTab activeTab;

  /// Currently inspected period detail for the bottom sheet, if any.
  final SelectedPeriodDetail? selectedPeriod;

  /// Creates a [DeckProgressLoaded] state.
  const DeckProgressLoaded({
    required this.progress,
    this.activeTab = DeckProgressPeriodTab.year,
    this.selectedPeriod,
  });

  /// Creates a copy of this state with updated fields.
  DeckProgressLoaded copyWith({
    DeckProgressData? progress,
    DeckProgressPeriodTab? activeTab,
    SelectedPeriodDetail? selectedPeriod,
    bool clearSelectedPeriod = false,
  }) {
    return DeckProgressLoaded(
      progress: progress ?? this.progress,
      activeTab: activeTab ?? this.activeTab,
      selectedPeriod: clearSelectedPeriod
          ? null
          : (selectedPeriod ?? this.selectedPeriod),
    );
  }
}

/// Error state when querying progress data fails.
final class DeckProgressError extends DeckProgressState {
  /// Error message.
  final String message;

  /// Creates a [DeckProgressError].
  const DeckProgressError(this.message);
}
