import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginHeader extends StatelessWidget {
  final int current;
  final int total;

  const LoginHeader({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final c = theme.colorScheme;
    final t = theme.textTheme;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: c.surfaceContainer,
                      border: BoxBorder.all(
                        color: c.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Symbols.arrow_back,
                      size: 16,
                      weight: 700,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  l.newProfile_title,
                  style: t.labelMedium,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: c.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                // "${current + 1} dari $total",
                l.step(current + 1, total),
                style: t.labelSmall,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: List.generate(2 * total - 1, (index) {
            if ((index + 1) % 2 == 0) {
              return SizedBox(width: 8);
            }
      
            final currentBox = (index / 2).toInt();
            final isActive = currentBox <= current;
            final backgroundColor = isActive
              ? c.primary
              : c.outline;
        
            return Expanded(
              child: Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}