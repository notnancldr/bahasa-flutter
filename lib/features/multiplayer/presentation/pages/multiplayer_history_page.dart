import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/features/decks/deck_details/data/datasources/deck_details_local_data_source.dart';
import 'package:bahasa/features/multiplayer/data/datasources/multiplayer_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen listing previous multiplayer quiz sessions from SQLite.
class MultiplayerHistoryPage extends StatefulWidget {
  final MultiplayerLocalDataSource? localDataSource;

  const MultiplayerHistoryPage({super.key, this.localDataSource});

  @override
  State<MultiplayerHistoryPage> createState() => _MultiplayerHistoryPageState();
}

class _MultiplayerHistoryPageState extends State<MultiplayerHistoryPage> {
  late final MultiplayerLocalDataSource _dataSource;
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dataSource = widget.localDataSource ?? MultiplayerLocalDataSourceImpl();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await _dataSource.getMultiplayerHistory();
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  String _formatDuration(int durationMs) {
    final totalSeconds = (durationMs / 1000).round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes}m ${seconds}d';
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: CircleBackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/multiplayer');
                }
              },
            ),
          ),
        ),
        title: Text(
          l.multiplayer_history_title,
          style: t.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _history.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.history_toggle_off,
                      size: 56,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l.deck_history_empty_title,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _history.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _history[index];
                  final deckTitle = item['deckTitle'] as String? ?? 'Deck';
                  final correct = item['correctCount'] as int? ?? 0;
                  final total = item['totalQuestions'] as int? ?? 10;
                  final duration = item['duration'] as int? ?? 0;
                  final startedAt = item['startedAt'] as int? ?? 0;
                  final dateStr = DeckDetailsLocalDataSourceImpl.formatDateKey(
                    DateTime.fromMillisecondsSinceEpoch(startedAt),
                  );

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2630) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2E3846)
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E3A4A)
                                : const Color(0xFFBCE7F0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Symbols.groups,
                            size: 24,
                            color: Color(0xFF1D4A5C),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deckTitle,
                                style: t.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$dateStr • ${_formatDuration(duration)}',
                                style: t.bodySmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E3A2A)
                                : const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$correct / $total',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
