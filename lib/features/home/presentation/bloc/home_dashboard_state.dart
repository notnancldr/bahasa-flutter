import 'package:bahasa/features/home/domain/entities/home_activity.dart';
import 'package:flutter/material.dart';

/// State of the Home dashboard.
@immutable
class HomeDashboardState {
  /// The user's active streak in consecutive days.
  final int streakCount;

  /// Optional recommended deck to review (e.g. least active deck).
  final ReviewRecommendationItem? recommendation;

  /// List of recent deck activities.
  final List<RecentActivityItem> recentActivities;

  /// Whether the user has any decks available.
  final bool hasDecks;

  const HomeDashboardState({
    required this.streakCount,
    required this.hasDecks,
    this.recommendation,
    this.recentActivities = const [],
  });

  /// Factory providing sample initial state matching the design mockups.
  /// Set [hasDecks] to true to view the active state with streak 7 and activities,
  /// or false to view the empty state with streak 0.
  factory HomeDashboardState.initial({bool hasDecks = true}) {
    if (!hasDecks) {
      return const HomeDashboardState(
        streakCount: 0,
        hasDecks: false,
        recommendation: null,
        recentActivities: [],
      );
    }

    return const HomeDashboardState(
      streakCount: 7,
      hasDecks: true,
      recommendation: ReviewRecommendationItem(
        id: 'deck-grammar-2',
        tag: 'Jarang Dipelajari',
        title: 'Tata Bahasa Modul 2',
        subtitle: 'Terakhir dipelajari 12 hari lalu.',
      ),
      recentActivities: [
        RecentActivityItem(
          id: 'deck-jlpt-n5',
          title: 'Kosakata JLPT N5',
          cardsCount: 15,
          timeValue: 2,
          timeUnit: 'hoursAgo',
          icon: Icons.style,
          color: Color(0xFFE59866),
        ),
        RecentActivityItem(
          id: 'deck-cafe-conv',
          title: 'Percakapan Kafe',
          cardsCount: 8,
          timeValue: 0,
          timeUnit: 'yesterday',
          icon: Icons.translate,
          color: Color(0xFF9B82C4),
        ),
        RecentActivityItem(
          id: 'deck-basic-verbs',
          title: 'Kata Kerja Dasar',
          cardsCount: 20,
          timeValue: 3,
          timeUnit: 'daysAgo',
          icon: Icons.format_quote,
          color: Color(0xFFE59866),
        ),
      ],
    );
  }
}
