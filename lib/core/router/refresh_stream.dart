import 'dart:async';
import 'package:flutter/foundation.dart';

/// Bridges a Bloc/Cubit stream to GoRouter's `refreshListenable`,
/// so route redirects re-evaluate whenever auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}