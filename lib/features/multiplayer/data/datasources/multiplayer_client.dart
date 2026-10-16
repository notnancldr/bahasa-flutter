import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../domain/entities/multiplayer_game_state.dart';
import '../../domain/entities/multiplayer_player.dart';

/// Network client connecting guesser devices to the host's [MultiplayerServer].
class MultiplayerClient {
  final HttpClient Function()? _clientProvider;

  HttpClient? _activeSseClient;
  StreamSubscription<String>? _activeSseSub;

  MultiplayerClient([this._clientProvider]);

  HttpClient _createClient() =>
      _clientProvider != null ? _clientProvider() : HttpClient();

  /// Resolves user input into a validated HTTP [Uri] targeting the host server.
  Uri resolveHostUri(String hostInput) {
    final trimmed = hostInput.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Host address cannot be empty.');
    }

    final formatted =
        trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : 'http://$trimmed';

    final parsed = Uri.tryParse(formatted);
    if (parsed == null || parsed.host.isEmpty) {
      throw FormatException('Invalid host address: $hostInput');
    }

    final port = parsed.hasPort && parsed.port != 0 ? parsed.port : 7001;
    return Uri(scheme: 'http', host: parsed.host, port: port);
  }

  /// Pings host at [baseUri] with a timeout to verify connectivity.
  Future<bool> checkHost(
    Uri baseUri, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final client = _createClient();
    try {
      final target = baseUri.replace(path: '/check');
      final request = await client.getUrl(target).timeout(timeout);
      final response = await request.close().timeout(timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  /// Registers guesser with host and returns host player metadata.
  Future<MultiplayerPlayer> join(
    Uri baseUri,
    MultiplayerPlayer guesser, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final client = _createClient();
    try {
      final target = baseUri.replace(path: '/api/join');
      final request = await client.postUrl(target).timeout(timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final payload = jsonEncode(guesser.toJson());
      request.write(payload);

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw HttpException('Host rejected join request: $responseBody');
      }

      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      final hostJson = json['host'] as Map<String, dynamic>?;
      if (hostJson == null) {
        throw const HttpException('Host profile missing in response.');
      }

      return MultiplayerPlayer.fromJson(hostJson);
    } finally {
      client.close(force: true);
    }
  }

  /// Connects to the host's SSE endpoint and yields [MultiplayerGameState] updates.
  Stream<MultiplayerGameState> connectEventStream(Uri baseUri) {
    final controller = StreamController<MultiplayerGameState>.broadcast();

    void startStream() async {
      await disconnectEventStream();
      final client = _createClient();
      _activeSseClient = client;

      try {
        final target = baseUri.replace(path: '/api/events');
        final request = await client.getUrl(target);
        request.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
        request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');

        final response = await request.close();
        if (response.statusCode != 200) {
          controller.addError(
            HttpException(
              'SSE connection failed with status ${response.statusCode}',
            ),
          );
          return;
        }

        final sub = response
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (line) {
                if (line.startsWith('data: ')) {
                  final jsonStr = line.substring(6).trim();
                  if (jsonStr.isNotEmpty) {
                    try {
                      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
                      final state = MultiplayerGameState.fromJson(json);
                      if (!controller.isClosed) {
                        controller.add(state);
                      }
                    } catch (e) {
                      // Ignore malformed line
                    }
                  }
                }
              },
              onError: (e) {
                if (!controller.isClosed) {
                  controller.addError(e);
                }
              },
              onDone: () {
                if (!controller.isClosed) {
                  controller.close();
                }
              },
              cancelOnError: true,
            );
        _activeSseSub = sub;
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    controller.onListen = startStream;
    controller.onCancel = disconnectEventStream;

    return controller.stream;
  }

  /// Submits the guesser's selected option to the host.
  Future<void> sendAnswer(
    Uri baseUri,
    String answer, {
    Duration timeout = const Duration(seconds: 6),
  }) async {
    final client = _createClient();
    try {
      final target = baseUri.replace(path: '/api/answer');
      final request = await client.postUrl(target).timeout(timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final payload = jsonEncode({'answer': answer});
      request.write(payload);

      final response = await request.close().timeout(timeout);
      if (response.statusCode != 200) {
        throw HttpException(
          'Host failed to accept answer: ${response.statusCode}',
        );
      }
    } finally {
      client.close(force: true);
    }
  }

  /// Notifies host that the guesser is leaving.
  Future<void> leave(Uri baseUri) async {
    final client = _createClient();
    try {
      final target = baseUri.replace(path: '/api/leave');
      final request = await client
          .postUrl(target)
          .timeout(const Duration(seconds: 3));
      await request.close();
    } catch (_) {
      // Best-effort notification
    } finally {
      client.close(force: true);
      await disconnectEventStream();
    }
  }

  /// Closes active SSE stream subscription and HTTP client.
  Future<void> disconnectEventStream() async {
    await _activeSseSub?.cancel();
    _activeSseSub = null;
    _activeSseClient?.close(force: true);
    _activeSseClient = null;
  }
}
