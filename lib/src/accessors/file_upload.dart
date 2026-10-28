import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';

/// This is inclusive-exclusive.
typedef FileReadCallback = Stream<Uint8List> Function(int start, int end);

final class const FileUploadAccessor({
  final String fileCategory = 'selecfile',

  required final String fileName,
  required final int fileLength,
  required final FileReadCallback readCallback,
  final String? mimeType,

  /// The hash must be MD5.
  final String? fileHash,

  required final String nextCallName,
}) extends Accessor<String> {
  static const int _chunkSize = 100 * 1024; // Same as remote

  @override
  bool get exclusiveFriendly => false;

  @override
  // Can be either in a lot of places.
  int? get page => null;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    final baseOrder = await session.stack.getEncryptedOrder(
      .communication,
      forceNullIv: false,
    );
    final uploadStart = DateTime.now();
    final fileId = UploadCallData.buildFileId(session.stack, fileCategory);
    session.stack.log.info(
      'Starting an upload at ${uploadStart.millisecondsSinceEpoch} for $fileId',
    );

    String? mimeType = this.mimeType;
    session.stack.log.fine('File size is $fileLength');

    int currentOffset = 0;
    while (currentOffset < fileLength) {
      final viewEnd = min(fileLength, currentOffset + _chunkSize);
      final viewData = await ByteStream(readCallback(currentOffset, viewEnd))
          .toBytes();

      if (currentOffset == 0) {
        mimeType ??= lookupMimeType(
          fileName,
          headerBytes: viewData
              .take(defaultMagicNumbersMaxLength)
              .toList(growable: false),
        );
      }

      session.stack.log.fine(
        'Uploading chunk $currentOffset-$viewEnd/$fileLength... '
        '(actual view data len = ${viewData.length}, '
        'requested = ${viewEnd - currentOffset})',
      );

      final result = await session.stack
          .post(
            .upload(
              cancellationSignal: cancellationSignal,
              data: .new(
                orderId: baseOrder,
                fileName: fileName,
                contentType: mimeType,
                contentLength: fileLength,
                viewOffset: currentOffset,
                dataView: viewData,
                fileId: fileId,
                md5DataHash: fileHash,
                uploadStartTime: uploadStart,
              ),
              name: nextCallName,
            ),
          )
          .resultCompleter
          .future;

      session.stack.log.fine('Uploaded chunk. Got $result');

      currentOffset += _chunkSize;
    }

    return {'fileId': fileId};
  }

  @override
  FutureOr<String> interpret(Map<String, dynamic> nav, RemoteSession session) =>
      nav.get('fileId');

  @override
  List<VisualNavigator> store(String result) => [];
}
