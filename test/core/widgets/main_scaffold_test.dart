import 'package:bahasa/core/theme/app_theme.dart';
import 'package:bahasa/core/widgets/main_scaffold.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute(
          branches: [
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) =>
                      const Scaffold(body: Text('Home Content')),
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: '/multiplayer',
                  builder: (context, state) =>
                      const Scaffold(body: Text('Multiplayer Content')),
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: '/deck',
                  builder: (context, state) =>
                      const Scaffold(body: Text('Deck Content')),
                ),
              ],
            ),
            StatefulShellBranch(
              preload: true,
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) =>
                      const Scaffold(body: Text('Settings Content')),
                ),
              ],
            ),
          ],
          builder: (context, state, navigationShell) => navigationShell,
          navigatorContainerBuilder: (context, navigationShell, children) {
            return MainScaffold(
              navigationShell: navigationShell,
              children: children,
            );
          },
        ),
      ],
    );
  }

  Widget buildApp(GoRouter router) {
    return MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets(
    'MainScaffold renders PageView and localized bottom navbar tabs',
    (tester) async {
      final router = createTestRouter();

      await tester.pumpWidget(buildApp(router));
      await tester.pumpAndSettle();

      // Verify PageView is present
      expect(find.byType(PageView), findsOneWidget);

      // Verify localized navbar labels
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Multiplayer'), findsOneWidget);
      expect(find.text('Deck'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Initial active page is Home
      expect(find.text('Home Content'), findsOneWidget);
    },
  );

  testWidgets('Tapping navbar items navigates and animates PageView', (
    tester,
  ) async {
    final router = createTestRouter();

    await tester.pumpWidget(buildApp(router));
    await tester.pumpAndSettle();

    // Tap on Multiplayer tab
    await tester.tap(find.text('Multiplayer'));
    await tester.pumpAndSettle();

    expect(find.text('Multiplayer Content'), findsOneWidget);

    // Tap on Deck tab
    await tester.tap(find.text('Deck'));
    await tester.pumpAndSettle();

    expect(find.text('Deck Content'), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings Content'), findsOneWidget);

    // Tap on Settings again (active tab)
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings Content'), findsOneWidget);

    // Tap on Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home Content'), findsOneWidget);
  });

  testWidgets(
    'Swiping PageView switches active tab and updates navbar selection',
    (tester) async {
      final router = createTestRouter();

      await tester.pumpWidget(buildApp(router));
      await tester.pumpAndSettle();

      expect(find.text('Home Content'), findsOneWidget);

      // Swipe left from Home to Multiplayer
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Multiplayer Content'), findsOneWidget);

      // Swipe left from Multiplayer to Deck
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Deck Content'), findsOneWidget);

      // Swipe left from Deck to Settings
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Settings Content'), findsOneWidget);

      // Swipe right from Settings back to Deck
      await tester.drag(find.byType(PageView), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('Deck Content'), findsOneWidget);
    },
  );
}
