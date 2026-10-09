import 'package:flutter/material.dart';

class SettingsMetricCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final Widget contentWidget;
  final Color backgroundColor;
  final Color borderColor;

  const SettingsMetricCard({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.contentWidget,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              iconWidget,
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A868C),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          contentWidget,
        ],
      ),
    );
  }
}

