import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/deck_details_local_data_source.dart';
import '../../domain/usecases/get_deck_progress_usecase.dart';
import 'deck_progress_state.dart';

/// Cubit managing the Deck Progress pages (Active Time / Streak and Accuracy).
class DeckProgressCubit extends Cubit<DeckProgressState> {
  /// Use case for computing Deck Progress data and weakest cards.
  final GetDeckProgressUseCase getDeckProgressUseCase;
  final String _deckId;

  /// Creates a [DeckProgressCubit] for [_deckId].
  DeckProgressCubit(this._deckId, {required this.getDeckProgressUseCase})
    : super(const DeckProgressLoading());

  /// Loads progress metrics from SQLite.
  Future<void> loadProgress({DateTime? referenceDate}) async {
    emit(const DeckProgressLoading());
    try {
      final data = await getDeckProgressUseCase(
        _deckId,
        referenceDate: referenceDate,
      );
      emit(DeckProgressLoaded(progress: data));
    } catch (e) {
      emit(DeckProgressError(e.toString()));
    }
  }

  /// Switches between the `Bulan` (month bar chart) and `Tahun` (calendar heatmap) tabs.
  void selectTab(DeckProgressPeriodTab tab) {
    final current = state;
    if (current is! DeckProgressLoaded) return;
    emit(current.copyWith(activeTab: tab, clearSelectedPeriod: true));
  }

  /// Selects a calendar day cell and resolves its stats + Top 3 Weakest Cards.
  Future<SelectedPeriodDetail?> selectDay(DateTime day) async {
    final current = state;
    if (current is! DeckProgressLoaded) return null;

    final normalized = DateTime(day.year, day.month, day.day);
    final key = DeckDetailsLocalDataSourceImpl.formatDateKey(normalized);
    final stat = current.progress.dailyStatsByDateKey[key];

    final startMs = normalized.millisecondsSinceEpoch;
    final endMs = normalized
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1))
        .millisecondsSinceEpoch;

    final weakest = await getDeckProgressUseCase.getWeakestCardsForRange(
      _deckId,
      startEpochMs: startMs,
      endEpochMs: endMs,
    );

    final detail = SelectedPeriodDetail(
      badgeNumber: normalized.day,
      date: normalized,
      isMonth: false,
      cardsPracticed: stat?.cardsPracticed ?? 0,
      accuracyPercent: stat?.accuracyRate.round().clamp(0, 100) ?? 0,
      activeMinutes: stat?.activeMinutes ?? 0,
      weakestCards: weakest,
    );

    if (!isClosed && state is DeckProgressLoaded) {
      emit((state as DeckProgressLoaded).copyWith(selectedPeriod: detail));
    }
    return detail;
  }

  /// Selects a month bar (`1..12`) and resolves its stats + Top 3 Weakest Cards.
  Future<SelectedPeriodDetail?> selectMonth(int month) async {
    final current = state;
    if (current is! DeckProgressLoaded) return null;

    final year = current.progress.referenceDate.year;
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(
      year,
      month + 1,
      1,
    ).subtract(const Duration(milliseconds: 1));

    final point = current.progress.monthlyStats[month - 1];
    final weakest = await getDeckProgressUseCase.getWeakestCardsForRange(
      _deckId,
      startEpochMs: monthStart.millisecondsSinceEpoch,
      endEpochMs: monthEnd.millisecondsSinceEpoch,
    );

    final detail = SelectedPeriodDetail(
      badgeNumber: month,
      date: monthStart,
      isMonth: true,
      cardsPracticed: point.cardsPracticed,
      accuracyPercent: point.accuracyPercent,
      activeMinutes: point.activeMinutes,
      weakestCards: weakest,
    );

    if (!isClosed && state is DeckProgressLoaded) {
      emit((state as DeckProgressLoaded).copyWith(selectedPeriod: detail));
    }
    return detail;
  }
}
