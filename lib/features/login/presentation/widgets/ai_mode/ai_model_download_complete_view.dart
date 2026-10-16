import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Completion view displayed when local model download succeeds.
class AiModelDownloadCompleteView extends StatelessWidget {
  final VoidCallback onDone;

  const AiModelDownloadCompleteView({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Success Check Graphic with concentric rings and decorative dots
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE2F3F5).withAlpha(150),
                  ),
                ),
                // Inner ring
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEAF8F9),
                    border: Border.all(
                      color: const Color(0xFFB5E4E8),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Symbols.check,
                      color: Color(0xFF264653),
                      size: 48,
                      weight: 800,
                    ),
                  ),
                ),

                // Decorative accent dots
                Positioned(
                  top: 18,
                  left: 30,
                  child: _buildDot(8, const Color(0xFF98D8C8)),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  child: _buildDot(7, const Color(0xFFB0DFE5)),
                ),
                Positioned(
                  bottom: 24,
                  right: 36,
                  child: _buildDot(8, const Color(0xFF98D8C8)),
                ),
                Positioned(
                  top: 28,
                  right: 32,
                  child: const Icon(
                    Symbols.chevron_left,
                    color: Color(0xFF98D8C8),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Title
          Text(
            l.ai_download_complete_title,
            textAlign: TextAlign.center,
            style: t.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF263238),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l.ai_download_complete_subtitle,
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(
                color: const Color(0xFF546E7A),
                height: 1.4,
                fontSize: 14,
              ),
            ),
          ),

          const Spacer(flex: 3),

          // Selesai Button
          EmbossedButton(l.ai_download_complete_button, onPressed: onDone),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
