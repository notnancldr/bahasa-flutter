import 'package:bahasa/core/utils/widget_var.dart';
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
    final WidgetVars(:c, :s, :theme) = WidgetVars.of(context);

    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;

    return ClipRRect(
      borderRadius: cardShape.borderRadius,
      child: Card(
        child: InkWell(
          onTap: () {
            context.push(route);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
