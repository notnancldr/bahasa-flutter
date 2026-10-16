import 'dart:io';

import 'package:bahasa/core/errors/settings_error.dart';
import 'package:bahasa/features/settings/data/datasources/data_transfer_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DataTransferClientImpl client;

  setUp(() {
    client = const DataTransferClientImpl();
  });

  group('DataTransferClientImpl.resolveReceiverUri', () {
    test('resolves simple IP by adding http scheme and port 7000', () {
      final uri = client.resolveReceiverUri('192.168.1.42');
      expect(uri.scheme, 'http');
      expect(uri.host, '192.168.1.42');
      expect(uri.port, 7000);
    });

    test('resolves IP with custom port', () {
      final uri = client.resolveReceiverUri('192.168.1.42:8080');
      expect(uri.scheme, 'http');
      expect(uri.host, '192.168.1.42');
      expect(uri.port, 8080);
    });

    test('resolves full URL with trailing slash', () {
      final uri = client.resolveReceiverUri('http://192.168.1.42:7000/');
      expect(uri.scheme, 'http');
      expect(uri.host, '192.168.1.42');
      expect(uri.port, 7000);
    });

    test('throws DataTransferFailure on empty address', () {
      expect(
        () => client.resolveReceiverUri('   '),
        throwsA(isA<DataTransferFailure>()),
      );
    });
  });

  group('DataTransferClientImpl.checkReceiver and sendTransferFile', () {
    late HttpServer mockServer;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('client_test_');
      mockServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    });

    tearDown(() async {
      await mockServer.close(force: true);
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('checkReceiver returns true when endpoint responds 200 OK', () async {
      mockServer.listen((request) {
        if (request.uri.path == '/check') {
          request.response
            ..statusCode = HttpStatus.ok
            ..write('OK')
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });

      final baseUri = Uri.parse('http://127.0.0.1:${mockServer.port}');
      final isOnline = await client.checkReceiver(baseUri);
      expect(isOnline, isTrue);
    });

    test(
      'checkReceiver returns false when unreachable or server down',
      () async {
        final closedPort = mockServer.port;
        await mockServer.close(force: true);

        final baseUri = Uri.parse('http://127.0.0.1:$closedPort');
        final isOnline = await client.checkReceiver(baseUri);
        expect(isOnline, isFalse);
      },
    );

    test('sendTransferFile streams file to /transfer endpoint', () async {
      bool receivedTransfer = false;
      mockServer.listen((request) async {
        if (request.uri.path == '/transfer') {
          receivedTransfer = true;
          await request.drain<void>();
          request.response
            ..statusCode = HttpStatus.ok
            ..write('{"success": true}')
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });

      final testFile = File('${tempDir.path}/test_payload.json');
      await testFile.writeAsString('{"hello": "world"}');

      final baseUri = Uri.parse('http://127.0.0.1:${mockServer.port}');
      final bytesSent = await client.sendTransferFile(baseUri, testFile);

      expect(receivedTransfer, isTrue);
      expect(bytesSent, greaterThan(0));
    });
  });
}
