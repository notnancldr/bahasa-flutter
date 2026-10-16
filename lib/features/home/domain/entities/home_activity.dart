import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Entity representing a recent activity item shown on the Home page.
@immutable
class RecentActivityItem {
  /// Unique identifier of the activity or associated deck.
  final String id;

  /// Display title of the deck.
  final String title;

  /// Number of cards practiced.
  final int cardsCount;

  /// Numeric time value (e.g. 2 for 2 hours ago, 3 for 3 days ago, 0 for yesterday).
  final int timeValue;

  /// Time unit key for localization ('hoursAgo', 'yesterday', 'daysAgo').
  final String timeUnit;

  /// Associated icon for the deck topic.
  final IconData icon;

  /// Primary accent color for the circular icon background.
  final Color color;

  const RecentActivityItem({
    required this.id,
    required this.title,
    required this.cardsCount,
    required this.timeValue,
    required this.timeUnit,
    required this.icon,
    required this.color,
  });

  /// Formats the localized subtitle string using AppLocalizations.
  String formatSubtitle(AppLocalizations l) {
    return l.home_recentActivitySubtitle(cardsCount, timeValue, timeUnit);
  }
}

/// Entity representing a deck recommended for review.
@immutable
class ReviewRecommendationItem {
  /// Unique identifier of the deck.
  final String id;

  /// Tag badge text (e.g. 'Jarang Dipelajari').
  final String tag;

  /// Display title of the deck.
  final String title;

  /// Relative study time text.
  final String subtitle;

  const ReviewRecommendationItem({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
  });
}
