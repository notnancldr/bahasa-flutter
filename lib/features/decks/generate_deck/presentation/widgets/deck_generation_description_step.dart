import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';

/// Step 4: Description textarea with character counter (max 200).
class DeckGenerationDescriptionStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DeckGenerationDescriptionStep({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DeckGenerationDescriptionStep> createState() =>
      _DeckGenerationDescriptionStepState();
}

class _DeckGenerationDescriptionStepState
    extends State<DeckGenerationDescriptionStep> {
  late final TextEditingController _controller;
  static const int maxLength = 200;

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
    final currentLength = _controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          l.deck_gen_desc_title,
          style: t.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: c.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.deck_gen_desc_subtitle,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: _controller,
          maxLength: maxLength,
          maxLines: 5,
          onChanged: (val) {
            setState(() {});
            widget.onChanged(val);
          },
          buildCounter: (
            _, {
            required currentLength,
            required isFocused,
            maxLength,
          }) => null,
          decoration: InputDecoration(
            hintText: l.deck_gen_desc_hint,
            filled: true,
            fillColor: c.surfaceContainerHighest,
            contentPadding: const EdgeInsets.all(16),
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
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$currentLength/$maxLength',
            style: t.labelSmall?.copyWith(color: c.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
