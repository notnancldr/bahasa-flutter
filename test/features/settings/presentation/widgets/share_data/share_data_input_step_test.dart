import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/features/settings/presentation/widgets/share_data/share_data_input_step.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

void main() {
  testWidgets(
    'ShareDataInputStep renders IP field, or divider, and QR scanner button',
    (tester) async {
      final controller = TextEditingController();
      bool transferStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ShareDataInputStep(
              controller: controller,
              onStartTransfer: () {
                transferStarted = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify IP text field exists
      expect(find.byType(TextField), findsOneWidget);

      // 2. Verify "or" / "atau" divider text exists
      expect(find.text('or'), findsOneWidget);

      // 3. Verify Scan QR Code button exists with Symbols.qr_code_scanner icon
      expect(find.text('Scan QR Code'), findsOneWidget);
      expect(find.byIcon(Symbols.qr_code_scanner), findsOneWidget);

      // 4. Verify Start Transfer button exists
      expect(find.text('Start Transfer'), findsOneWidget);

      // 5. Verify tapping Start Transfer triggers callback
      await tester.tap(find.text('Start Transfer'));
      expect(transferStarted, isTrue);

      // 6. Verify tapping Scan QR Code opens modal bottom sheet
      await tester.tap(find.text('Scan QR Code'));
      await tester.pump();
      expect(find.text('Scan Receiver QR'), findsOneWidget);
    },
  );
}
