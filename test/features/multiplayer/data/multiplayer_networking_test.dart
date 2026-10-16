import 'package:bahasa/features/multiplayer/data/datasources/multiplayer_client.dart';
import 'package:bahasa/features/multiplayer/data/datasources/multiplayer_server.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_game_state.dart';
import 'package:bahasa/features/multiplayer/domain/entities/multiplayer_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';

class MockNetworkInfo implements NetworkInfo {
  @override
  Future<String?> getWifiIP() async => '127.0.0.1';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Multiplayer Networking (Server & Client)', () {
    late MultiplayerServer server;
    late MultiplayerClient client;
    const testPort = 7088;

    setUp(() {
      server = MultiplayerServer(
        port: testPort,
        networkInfo: MockNetworkInfo(),
      );
      client = MultiplayerClient();
    });

    tearDown(() async {
      await server.dispose();
      await client.disconnectEventStream();
    });

    test(
      'Host starts server and Client connects, joins, and receives events',
      () async {
        const host = MultiplayerPlayer(
          id: 'h1',
          name: 'Santi',
          isHost: true,
          badgeText: 'P1',
        );

        final ip = await server.start(hostPlayer: host);
        expect(ip, '127.0.0.1');

        final baseUri = Uri.parse('http://127.0.0.1:$testPort');

        // Pre-flight check
        final isAlive = await client.checkHost(baseUri);
        expect(isAlive, isTrue);

        // Join room
        const guesser = MultiplayerPlayer(
          id: 'g1',
          name: 'Rian',
          isHost: false,
          badgeText: 'P2',
        );

        final receivedHost = await client.join(baseUri, guesser);
        expect(receivedHost.name, 'Santi');
        expect(receivedHost.isHost, isTrue);

        // Broadcast state
        server.broadcastState(
          const MultiplayerGameState(
            phase: MultiplayerPhase.lobby,
            hostPlayer: host,
            guesserPlayer: guesser,
          ),
        );

        // Connect SSE stream
        final sseStream = client.connectEventStream(baseUri);
        final state = await sseStream.first.timeout(const Duration(seconds: 4));
        expect(state.phase, MultiplayerPhase.lobby);
        expect(state.hostPlayer?.name, 'Santi');
        expect(state.guesserPlayer?.name, 'Rian');
      },
    );

    test('Guesser submits answer to host server', () async {
      const host = MultiplayerPlayer(
        id: 'h1',
        name: 'Santi',
        isHost: true,
        badgeText: 'P1',
      );

      await server.start(hostPlayer: host);
      final baseUri = Uri.parse('http://127.0.0.1:$testPort');

      final serverEventFuture = server.events.first;
      await client.sendAnswer(baseUri, 'Halo');

      final event = await serverEventFuture.timeout(const Duration(seconds: 4));
      expect(event, isA<MultiplayerGuesserAnswerReceived>());
      expect((event as MultiplayerGuesserAnswerReceived).answer, 'Halo');
    });
  });
}
