import 'dart:io';

import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/deck_db_loader.dart';
import 'package:bahasa/core/utils/main_db_loader.dart';
import 'package:bahasa/features/home/domain/entities/home_activity.dart';
import 'package:bahasa/features/home/presentation/bloc/home_dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Data source responsible for querying SQLite databases to construct the Home dashboard.
abstract class HomeLocalDataSource {
  /// Queries database records to construct [HomeDashboardState].
  Future<HomeDashboardState> getDashboardData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final MainDbLoader _mainDbLoader;
  final DeckDbLoader _deckDbLoader;
  final Directory? _overrideStorageDirectory;

  const HomeLocalDataSourceImpl({
    MainDbLoader? mainDbLoader,
    DeckDbLoader? deckDbLoader,
    this._overrideStorageDirectory,
  }) : _mainDbLoader = mainDbLoader ?? const MainDbLoader(),
       _deckDbLoader = deckDbLoader ?? const DeckDbLoader();

  @override
  Future<HomeDashboardState> getDashboardData() async {
    final mainDb = await _mainDbLoader.openDatabase(
      overrideDirectory: _overrideStorageDirectory,
    );

    try {
      // 1. Check if any decks exist
      final deckRows = mainDb.select('''
        SELECT id, name, language, difficulty, description, activeTime, lastStudiedAt, createdAt, updatedAt
        FROM decks
        ORDER BY COALESCE(lastStudiedAt, updatedAt) DESC;
      ''');

      if (deckRows.isEmpty) {
        return const HomeDashboardState(
          streakCount: 0,
          hasDecks: false,
          recommendation: null,
          recentActivities: [],
        );
      }

      // 2. Calculate consecutive streak from global_daily_activity
      final activityRows = mainDb.select('''
        SELECT date, activeTime, cardsReviewed
        FROM global_daily_activity
        ORDER BY date DESC;
      ''');

      final streakCount = _calculateStreak(activityRows);

      // 3. Find recommended / least active deck
      final recommendation = _findRecommendation(deckRows);

      // 4. Build recent activities (up to 5 decks)
      final recentActivities = await _buildRecentActivities(
        deckRows.take(5).toList(),
      );

      return HomeDashboardState(
        streakCount: streakCount,
        hasDecks: true,
        recommendation: recommendation,
        recentActivities: recentActivities,
      );
    } finally {
      mainDb.close();
    }
  }

  int _calculateStreak(List<Map<String, dynamic>> activityRows) {
    if (activityRows.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    int streak = 0;
    DateTime? expectedDate;
    bool started = false;

    for (final row in activityRows) {
      final cardsReviewed = row['cardsReviewed'] as int? ?? 0;
      final activeTime = row['activeTime'] as int? ?? 0;
      if (cardsReviewed <= 0 && activeTime <= 0) continue;

      final dateStr = row['date'] as String?;
      if (dateStr == null) continue;

      final parsed = DateTime.tryParse(dateStr);
      if (parsed == null) continue;
      final normalized = DateTime(parsed.year, parsed.month, parsed.day);

      if (!started) {
        if (normalized == today) {
          started = true;
          streak++;
          expectedDate = yesterday;
        } else if (normalized == yesterday) {
          started = true;
          streak++;
          expectedDate = yesterday.subtract(const Duration(days: 1));
        } else {
          // Last activity was older than yesterday
          break;
        }
      } else {
        if (expectedDate != null && normalized == expectedDate) {
          streak++;
          expectedDate = expectedDate.subtract(const Duration(days: 1));
        } else if (expectedDate != null && normalized.isBefore(expectedDate)) {
          // Gap in active days
          break;
        }
      }
    }

    return streak;
  }

  ReviewRecommendationItem? _findRecommendation(
    List<Map<String, dynamic>> allDecks,
  ) {
    if (allDecks.isEmpty) return null;

    // Sort: decks with null lastStudiedAt first, then oldest lastStudiedAt, then lowest activeTime
    final sorted = List<Map<String, dynamic>>.from(allDecks)
      ..sort((a, b) {
        final aStudied = a['lastStudiedAt'] as int?;
        final bStudied = b['lastStudiedAt'] as int?;

        if (aStudied == null && bStudied != null) return -1;
        if (aStudied != null && bStudied == null) return 1;
        if (aStudied != null && bStudied != null) {
          final cmp = aStudied.compareTo(bStudied);
          if (cmp != 0) return cmp;
        }

        final aTime = a['activeTime'] as int? ?? 0;
        final bTime = b['activeTime'] as int? ?? 0;
        return aTime.compareTo(bTime);
      });

    final target = sorted.first;
    final lastStudied = target['lastStudiedAt'] as int?;

    final String subtitle;
    if (lastStudied == null) {
      subtitle = 'Belum pernah dipelajari.';
    } else {
      final daysAgo = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastStudied))
          .inDays;
      if (daysAgo == 0) {
        subtitle = 'Terakhir dipelajari hari ini.';
      } else if (daysAgo == 1) {
        subtitle = 'Terakhir dipelajari kemarin.';
      } else {
        subtitle = 'Terakhir dipelajari $daysAgo hari lalu.';
      }
    }

    return ReviewRecommendationItem(
      id: target['id'] as String,
      tag: 'Jarang Dipelajari',
      title: target['name'] as String,
      subtitle: subtitle,
    );
  }

  Future<List<RecentActivityItem>> _buildRecentActivities(
    List<Map<String, dynamic>> decks,
  ) async {
    final now = DateTime.now();
    final items = <RecentActivityItem>[];

    final colors = [
      AppColors.primaryDark,
      const Color(0xFF9B82C4),
      const Color(0xFFE59866),
      AppColors.secondary,
    ];

    final icons = [
      Symbols.style,
      Symbols.translate,
      Symbols.format_quote,
      Symbols.auto_stories,
    ];

    for (var i = 0; i < decks.length; i++) {
      final deck = decks[i];
      final deckId = deck['id'] as String;
      final deckName = deck['name'] as String;
      final timestamp =
          (deck['lastStudiedAt'] as int?) ??
          (deck['updatedAt'] as int? ?? now.millisecondsSinceEpoch);

      // Query card count from deck_<uuid>.sqlite
      int cardCount = 0;
      try {
        final deckDb = await _deckDbLoader.openDeckDatabase(
          deckId,
          overrideDirectory: _overrideStorageDirectory,
        );
        try {
          final countRow = deckDb.select(
            'SELECT COUNT(*) as count FROM cards;',
          );
          if (countRow.isNotEmpty) {
            cardCount = countRow.first['count'] as int? ?? 0;
          }
        } finally {
          deckDb.close();
        }
      } catch (_) {
        cardCount = 0;
      }

      // Calculate relative time value & unit
      final diff = now.difference(
        DateTime.fromMillisecondsSinceEpoch(timestamp),
      );
      final int timeValue;
      final String timeUnit;

      if (diff.inHours < 24) {
        timeValue = diff.inHours.clamp(1, 23);
        timeUnit = 'hoursAgo';
      } else if (diff.inDays == 1) {
        timeValue = 0;
        timeUnit = 'yesterday';
      } else {
        timeValue = diff.inDays;
        timeUnit = 'daysAgo';
      }

      items.add(
        RecentActivityItem(
          id: deckId,
          title: deckName,
          cardsCount: cardCount,
          timeValue: timeValue,
          timeUnit: timeUnit,
          icon: icons[i % icons.length],
          color: colors[i % colors.length],
        ),
      );
    }

    return items;
  }
}
