import 'dart:async';

import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../bloc/generate_deck_state.dart';

/// Review summary step allowing the user to review choices and jump back to edit.
class DeckGenerationReviewStep extends StatefulWidget {
  final GenerateDeckWizardState state;
  final ValueChanged<int> onEditStep;
  final VoidCallback onCreateDeck;
  final VoidCallback onCancel;
  final SettingsRepository? settingsRepository;

  const DeckGenerationReviewStep({
    super.key,
    required this.state,
    required this.onEditStep,
    required this.onCreateDeck,
    required this.onCancel,
    this.settingsRepository,
  });

  @override
  State<DeckGenerationReviewStep> createState() =>
      _DeckGenerationReviewStepState();
}

class _DeckGenerationReviewStepState extends State<DeckGenerationReviewStep> {
  late final SettingsRepository _settingsRepository;
  bool _canGenerateOnline = true;
  bool _isOnlineModel = true;
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _settingsRepository =
        widget.settingsRepository ??
        SettingsDependencies.createSettingsRepository();
    _checkLimitAndStartTimer();
  }

  Future<void> _checkLimitAndStartTimer() async {
    final aiModel = await _settingsRepository.getAiModelPreference();
    final canGenerate = await _settingsRepository.canGenerateOnlineDeckToday();

    if (mounted) {
      setState(() {
        _isOnlineModel = aiModel == AiModelType.online;
        _canGenerateOnline = canGenerate;
      });
    }

    if (_isOnlineModel && !_canGenerateOnline) {
      _updateRemainingTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemainingTime();
      });
    }
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final remaining = nextMidnight.difference(now);

    if (mounted) {
      setState(() {
        _remainingTime = remaining.isNegative ? Duration.zero : remaining;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours}j ${minutes}m ${seconds}d';
  }

  String _formatDifficulty(String diff, WidgetVars v) {
    return switch (diff) {
      'beginner' => v.l.deck_gen_diff_beginner,
      'intermediate' => v.l.deck_gen_diff_intermediate,
      'expert' => v.l.deck_gen_diff_expert,
      _ => diff,
    };
  }

  @override
  Widget build(BuildContext context) {
    final v = WidgetVars.of(context);
    final WidgetVars(:c, :t, :l) = v;

    final langName = l.languageName(widget.state.language);
    final diffLabel = _formatDifficulty(widget.state.difficulty, v);
    final descText = widget.state.description.isEmpty ? '-' : widget.state.description;
    final isLimitBlocked = _isOnlineModel && !_canGenerateOnline;
    final formattedTime = _formatTime(_remainingTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_review_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_review_desc,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 24),

        // Summary Container Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.outline),
          ),
          child: Column(
            children: [
              _ReviewRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.title,
                label: l.deck_gen_name_label,
                value: widget.state.name,
                onEdit: () => widget.onEditStep(0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.tertiary,
                iconColor: const Color(0xFF5B21B6),
                icon: Symbols.public,
                label: l.deck_gen_country_title,
                value: langName,
                onEdit: () => widget.onEditStep(1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.secondary,
                iconColor: const Color(0xFF7C2D12),
                icon: Symbols.bar_chart,
                label: l.deck_gen_diff_title,
                value: diffLabel,
                onEdit: () => widget.onEditStep(2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: c.outlineVariant,
                ),
              ),
              _ReviewRow(
                badgeBg: AppColors.tertiary,
                iconColor: const Color(0xFF5B21B6),
                icon: Symbols.description,
                label: l.deck_gen_desc_title,
                value: descText,
                onEdit: () => widget.onEditStep(3),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Limit Countdown Banner Notice (if online limit reached)
        if (isLimitBlocked) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF87171), width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(
                  Symbols.schedule,
                  size: 20,
                  color: Color(0xFFDC2626),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.deck_gen_limit_reached_title(formattedTime),
                    style: t.bodySmall?.copyWith(
                      color: const Color(0xFF991B1B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Primary: Buat Deck Button (shows countdown label if limit blocked)
        EmbossedButton(
          isLimitBlocked
              ? l.deck_gen_limit_countdown_button(formattedTime)
              : l.deck_gen_create_button,
          onPressed: isLimitBlocked ? null : widget.onCreateDeck,
        ),
        const SizedBox(height: 12),

        // Secondary: Batal
        EmbossedButton(
          l.deck_gen_cancel_button,
          onPressed: widget.onCancel,
          type: EmbossedButtonType.outlined,
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final Color badgeBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _ReviewRow({
    required this.badgeBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :s, :l) = WidgetVars.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: t.labelSmall?.copyWith(color: c.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onEdit,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l.deck_gen_review_change,
            style: t.labelMedium?.copyWith(
              color: s.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
