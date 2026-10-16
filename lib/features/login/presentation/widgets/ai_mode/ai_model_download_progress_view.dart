import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Progress view displaying circular download indicator and background continuation action.
class AiModelDownloadProgressView extends StatelessWidget {
  final ModelDownloadProgress progress;
  final VoidCallback onContinueInBackground;

  const AiModelDownloadProgressView({
    super.key,
    required this.progress,
    required this.onContinueInBackground,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    final fraction = progress.progressFraction;
    final percentage = progress.percentage;
    final formattedProgress = progress.formattedProgress;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Title
          Text(
            l.ai_download_progress_title,
            textAlign: TextAlign.center,
            style: t.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF263238),
              fontSize: 20,
            ),
          ),

          const Spacer(),

          // Circular Progress Indicator
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Ring
                SizedBox(
                  width: 190,
                  height: 190,
                  child: CircularProgressIndicator(
                    value: fraction > 0 ? fraction : null,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFE8F2F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF5B93AE),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),

                // Center Content (Icon, Percentage, Size)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F0F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Symbols.description,
                        color: Color(0xFF457B9D),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$percentage%',
                      style: t.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF263238),
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedProgress,
                      style: t.labelMedium?.copyWith(
                        color: const Color(0xFF78909C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue in background action
          EmbossedButton(
            l.ai_download_continue_in_background,
            type: EmbossedButtonType.outlineMuted,
            onPressed: onContinueInBackground,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
