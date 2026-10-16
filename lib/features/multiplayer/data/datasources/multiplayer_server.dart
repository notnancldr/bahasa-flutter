import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bahasa/core/errors/transfer_error.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../../domain/entities/multiplayer_game_state.dart';
import '../../domain/entities/multiplayer_player.dart';

/// Events emitted by [MultiplayerServer] for local host consumption.
sealed class MultiplayerServerEvent {}

class MultiplayerClientJoined extends MultiplayerServerEvent {
  final MultiplayerPlayer player;
  MultiplayerClientJoined(this.player);
}

class MultiplayerGuesserAnswerReceived extends MultiplayerServerEvent {
  final String answer;
  MultiplayerGuesserAnswerReceived(this.answer);
}

class MultiplayerClientLeft extends MultiplayerServerEvent {}

/// Embedded Shelf HTTP and SSE server powering host-side multiplayer game synchronization.
class MultiplayerServer {
  final int port;
  final NetworkInfo _networkInfo;

  HttpServer? _server;
  final _eventController = StreamController<MultiplayerServerEvent>.broadcast();
  final List<StreamController<String>> _sseClients = [];

  MultiplayerPlayer? _hostPlayer;
  MultiplayerGameState? _latestState;

  MultiplayerServer({this.port = 7001, NetworkInfo? networkInfo})
    : _networkInfo = networkInfo ?? NetworkInfo();

  Stream<MultiplayerServerEvent> get events => _eventController.stream;

  bool get isRunning => _server != null;

  Router _createHandler() {
    final router = Router();

    // Connectivity probe
    router.get('/check', (Request request) => Response.ok('OK'));

    // Guesser registration
    router.post('/api/join', _handleJoin);

    // Real-time Server-Sent Events stream for guesser
    router.get('/api/events', _handleEvents);

    // Guesser answer submission
    router.post('/api/answer', _handleAnswer);

    // Disconnect notification
    router.post('/api/leave', _handleLeave);

    return router;
  }

  /// Starts the HTTP server on `0.0.0.0` at [port] and resolves local Wi-Fi IP.
  Future<String> start({required MultiplayerPlayer hostPlayer}) async {
    await stop();
    _hostPlayer = hostPlayer;

    final ip = await _networkInfo.getWifiIP();
    if (ip == null || ip.isEmpty) {
      throw NoHostIp();
    }

    final handler = _createHandler();
    _server = await io.serve(handler.call, '0.0.0.0', port);
    return ip;
  }

  /// Broadcasts updated state to all connected SSE clients.
  void broadcastState(MultiplayerGameState state) {
    _latestState = state;
    if (_sseClients.isEmpty) return;

    // Apply rule: If host gets answer wrong, guesser stays in waiting screen (hostAnswering phase)
    final guesserState = state.phase == MultiplayerPhase.hostWrongFeedback
        ? state.copyWith(phase: MultiplayerPhase.hostAnswering)
        : state;

    final payload = jsonEncode(guesserState.toJson());
    final message = 'data: $payload\n\n';

    final toRemove = <StreamController<String>>[];
    for (final client in _sseClients) {
      if (client.isClosed) {
        toRemove.add(client);
      } else {
        client.add(message);
      }
    }
    _sseClients.removeWhere(toRemove.contains);
  }

  Future<Response> _handleJoin(Request request) async {
    try {
      final bodyString = await request.readAsString();
      final body = jsonDecode(bodyString) as Map<String, dynamic>;
      final guesser = MultiplayerPlayer.fromJson(body);

      _eventController.add(MultiplayerClientJoined(guesser));

      return Response.ok(
        jsonEncode({'success': true, 'host': _hostPlayer?.toJson()}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({'success': false, 'error': e.toString()}),
      );
    }
  }

  Response _handleEvents(Request request) {
    final sseController = StreamController<String>();
    _sseClients.add(sseController);

    // Push initial or latest state immediately upon connection
    if (_latestState != null) {
      final guesserState =
          _latestState!.phase == MultiplayerPhase.hostWrongFeedback
          ? _latestState!.copyWith(phase: MultiplayerPhase.hostAnswering)
          : _latestState!;
      final payload = jsonEncode(guesserState.toJson());
      sseController.add('data: $payload\n\n');
    }

    request.context['shelf.io.connection_info'];

    return Response.ok(
      sseController.stream.map((s) => utf8.encode(s)),
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      },
      context: {'shelf.io.buffer_output': false},
    );
  }

  Future<Response> _handleAnswer(Request request) async {
    try {
      final bodyString = await request.readAsString();
      final body = jsonDecode(bodyString) as Map<String, dynamic>;
      final answer = body['answer'] as String? ?? '';

      _eventController.add(MultiplayerGuesserAnswerReceived(answer));

      return Response.ok(
        jsonEncode({'success': true}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({'success': false, 'error': e.toString()}),
      );
    }
  }

  Response _handleLeave(Request request) {
    _eventController.add(MultiplayerClientLeft());
    return Response.ok(
      jsonEncode({'success': true}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Stops server and closes client connections.
  Future<void> stop() async {
    for (final client in _sseClients) {
      if (!client.isClosed) {
        await client.close();
      }
    }
    _sseClients.clear();
    await _server?.close(force: true);
    _server = null;
    _hostPlayer = null;
    _latestState = null;
  }

  /// Disposes controllers and shuts down.
  Future<void> dispose() async {
    await stop();
    await _eventController.close();
  }
}
