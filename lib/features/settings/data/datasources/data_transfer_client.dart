import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bahasa/core/constants/server_routes.dart';
import 'package:bahasa/core/errors/settings_error.dart';

/// Network client responsible for sending transfer data to a remote receiver device.
abstract class DataTransferClient {
  /// Resolves an IP or host input into a standard [Uri] targeting the receiver server.
  Uri resolveReceiverUri(String receiverInput);

  /// Performs a pre-flight connectivity check against [baseUri].
  Future<bool> checkReceiver(
    Uri baseUri, {
    Duration timeout = const Duration(seconds: 4),
  });

  /// Uploads [file] to [baseUri] over HTTP multipart form-data.
  Future<int> sendTransferFile(
    Uri baseUri,
    File file, {
    Duration timeout = const Duration(seconds: 30),
  });
}

/// Default implementation of [DataTransferClient] using `dart:io` [HttpClient].
class DataTransferClientImpl implements DataTransferClient {
  final HttpClient Function()? _clientProvider;

  /// Creates a [DataTransferClientImpl] with an optional custom [clientProvider].
  const DataTransferClientImpl([this._clientProvider]);

  HttpClient _createClient() =>
      _clientProvider != null ? _clientProvider() : HttpClient();

  @override
  Uri resolveReceiverUri(String receiverInput) {
    final trimmed = receiverInput.trim();
    if (trimmed.isEmpty) {
      throw const DataTransferFailure('Receiver address cannot be empty.');
    }

    final formatted =
        trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : 'http://$trimmed';

    final parsed = Uri.tryParse(formatted);
    if (parsed == null || parsed.host.isEmpty) {
      throw DataTransferFailure('Invalid receiver address: $receiverInput');
    }

    final port = parsed.hasPort && parsed.port != 0 ? parsed.port : 7000;
    return Uri(scheme: 'http', host: parsed.host, port: port);
  }

  @override
  Future<bool> checkReceiver(
    Uri baseUri, {
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final client = _createClient();
    try {
      final target = baseUri.replace(path: checkPath);
      final request = await client.getUrl(target).timeout(timeout);
      final response = await request.close().timeout(timeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  @override
  Future<int> sendTransferFile(
    Uri baseUri,
    File file, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!await file.exists()) {
      throw const DataTransferFailure('Transfer payload file not found.');
    }

    final client = _createClient();
    try {
      final target = baseUri.replace(path: receivePath);
      final request = await client.postUrl(target).timeout(timeout);

      final boundary =
          '----BahasaTransferBoundary${DateTime.now().microsecondsSinceEpoch}';
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );

      final fileName = file.uri.pathSegments.isNotEmpty
          ? file.uri.pathSegments.last
          : 'bahasa_transfer_bundle.json';

      final header =
          '--$boundary\r\n'
          'Content-Disposition: form-data; name="file"; filename="$fileName"\r\n'
          'Content-Type: application/json\r\n\r\n';
      final headerBytes = utf8.encode(header);
      final footerBytes = utf8.encode('\r\n--$boundary--\r\n');
      final fileLength = await file.length();
      final totalLength = headerBytes.length + fileLength + footerBytes.length;

      request.contentLength = totalLength;

      request.add(headerBytes);
      await request.addStream(file.openRead());
      request.add(footerBytes);

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw DataTransferFailure(
          'Receiver rejected transfer (Status ${response.statusCode}): $responseBody',
        );
      }

      return totalLength;
    } catch (e) {
      if (e is SettingsFailure) rethrow;
      throw DataTransferFailure('Failed to send data to receiver: $e');
    } finally {
      client.close(force: true);
    }
  }
}
