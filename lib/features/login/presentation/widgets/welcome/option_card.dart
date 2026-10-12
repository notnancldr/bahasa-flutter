import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OptionCard extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final String route;

  final String title;
  final String description;
  final String nextText;

  const OptionCard({
    super.key,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.route,

    required this.title,
    required this.description,
    required this.nextText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = theme.extension<AppSemanticColors>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(route);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withAlpha(40), width: 3),
              color: Colors.grey.withAlpha(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: bgColor,
                  ),
                  child: Icon(icon, weight: 700, color: iconColor, size: 24),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey.shade500),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        nextText,
                        style: TextStyle(
                          color: s.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: s.primaryDark, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
