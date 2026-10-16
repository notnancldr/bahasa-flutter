import 'package:bahasa/features/decks/domain/entities/deck_item.dart';

import 'deck_card_item.dart';

/// Specifies which metric is focused on the Deck Progress page.
enum DeckProgressMetricType {
  /// Focuses on consecutive study streak and active time per period.
  streak,

  /// Focuses on study accuracy percentage per period.
  accuracy,
}

/// Summary statistics for a single calendar day in a deck's history.
class DailyStatSummary {
  /// Normalized local calendar date (`YYYY-MM-DD`).
  final DateTime date;

  /// Total active study time in milliseconds on this date.
  final int activeTimeMs;

  /// Total number of card questions practiced on this date.
  final int cardsPracticed;

  /// Total number of correct answers on this date.
  final int correctAnswer;

  /// Accuracy rate percentage (0.0 to 100.0) on this date.
  final double accuracyRate;

  /// Creates a [DailyStatSummary].
  const DailyStatSummary({
    required this.date,
    required this.activeTimeMs,
    required this.cardsPracticed,
    required this.correctAnswer,
    required this.accuracyRate,
  });

  /// Active time rounded up to minutes (or 0 if no active time).
  int get activeMinutes =>
      activeTimeMs <= 0 ? 0 : (activeTimeMs / 60000).ceil();
}

/// Aggregated statistics for a single month (1..12) in the yearly bar chart.
class MonthlyStatPoint {
  /// Month index from 1 (January) to 12 (December).
  final int month;

  /// Total active study time in milliseconds during this month.
  final int activeTimeMs;

  /// Total number of cards practiced during this month.
  final int cardsPracticed;

  /// Total number of correct answers during this month.
  final int correctAnswer;

  /// Average accuracy percentage (0..100) during this month.
  final int accuracyPercent;

  /// Creates a [MonthlyStatPoint].
  const MonthlyStatPoint({
    required this.month,
    required this.activeTimeMs,
    required this.cardsPracticed,
    required this.correctAnswer,
    required this.accuracyPercent,
  });

  /// Active time in minutes during this month.
  int get activeMinutes =>
      activeTimeMs <= 0 ? 0 : (activeTimeMs / 60000).ceil();
}

/// Represents one of the weakest cards in a deck or selected time period.
class WeakCardSummary {
  /// The underlying flashcard item.
  final DeckCardItem card;

  /// Number of incorrect answers recorded in the inspected period.
  final int wrongCount;

  /// Accuracy percentage (0..100) in the inspected period.
  final int accuracyPercent;

  /// Creates a [WeakCardSummary].
  const WeakCardSummary({
    required this.card,
    required this.wrongCount,
    required this.accuracyPercent,
  });
}

/// Complete progress dataset for the Active Time (Streak) and Accuracy pages.
class DeckProgressData {
  /// Deck metadata.
  final DeckItem deck;

  /// Current consecutive daily study streak for this deck.
  final int streakCount;

  /// Overall accuracy percentage (0..100) for this deck.
  final int overallAccuracyPercent;

  /// Accuracy percentage (0..100) for the current calendar month.
  final int thisMonthAccuracyPercent;

  /// Accuracy percentage (0..100) for the previous calendar month.
  final int lastMonthAccuracyPercent;

  /// Total active time in minutes for the current calendar month.
  final int thisMonthActiveMinutes;

  /// Total active time in minutes for the previous calendar month.
  final int lastMonthActiveMinutes;

  /// Active flags for Monday (index 0) through Sunday (index 6) of the current week.
  final List<bool> weeklyActiveDays;

  /// Map of `YYYY-MM-DD` date strings to their [DailyStatSummary].
  final Map<String, DailyStatSummary> dailyStatsByDateKey;

  /// 12 monthly data points (January = index 0 .. December = index 11) for the current year.
  final List<MonthlyStatPoint> monthlyStats;

  /// Top 3 weakest cards overall in the deck.
  final List<WeakCardSummary> overallWeakestCards;

  /// Reference date used to build calendar and monthly views.
  final DateTime referenceDate;

  /// Creates a [DeckProgressData] entity.
  const DeckProgressData({
    required this.deck,
    required this.streakCount,
    required this.overallAccuracyPercent,
    required this.thisMonthAccuracyPercent,
    required this.lastMonthAccuracyPercent,
    required this.thisMonthActiveMinutes,
    required this.lastMonthActiveMinutes,
    required this.weeklyActiveDays,
    required this.dailyStatsByDateKey,
    required this.monthlyStats,
    required this.overallWeakestCards,
    required this.referenceDate,
  });
}
