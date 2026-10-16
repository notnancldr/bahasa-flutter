import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Step 1: Input the deck title.
class DeckGenerationNameStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DeckGenerationNameStep({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DeckGenerationNameStep> createState() => _DeckGenerationNameStepState();
}

class _DeckGenerationNameStepState extends State<DeckGenerationNameStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_name_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_name_desc,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        Text(
          l.deck_gen_name_label,
          style: t.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l.deck_gen_name_hint,
            filled: true,
            fillColor: c.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: c.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: c.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
