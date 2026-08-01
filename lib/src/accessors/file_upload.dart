import 'dart:async';
import 'dart:math';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';

final class const FileUploadAccessor({
  final String fileCategory = 'selecfile',
  required final XFile file,
  required final String nextCallName,
}) extends StatelessAccessor<String> {
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
      OrderBehavior.communication,
      forceNullIv: false,
    );
    final uploadStart = DateTime.now();
    final fileId = UploadCallData.buildFileId(session.stack, fileCategory);
    session.stack.log.info(
      'Starting an upload at ${uploadStart.millisecondsSinceEpoch} for $fileId',
    );

    int contentLength = await file.length();
    String? mimeType;
    session.stack.log.fine('File size is $contentLength');

    int currentOffset = 0;
    while (currentOffset < contentLength) {
      final viewEnd = min(contentLength, currentOffset + _chunkSize) /* - 1*/;
      final viewData = await ByteStream(file.openRead(currentOffset, viewEnd))
          .toBytes();

      mimeType ??= lookupMimeType(
        file.name,
        headerBytes: viewData
            .take(defaultMagicNumbersMaxLength)
            .toList(growable: false),
      );

      session.stack.log.fine(
        'Uploading chunk $currentOffset-$viewEnd/$contentLength... (actual view data len = ${viewData.length}, requested = ${viewEnd - currentOffset})',
      );

      final result = await session.stack
          .post(
            .upload(
              cancellationSignal: cancellationSignal,
              data: UploadCallData(
                orderId: baseOrder,
                fileName: file.name,
                contentType: mimeType ?? file.mimeType,
                contentLength: contentLength,
                viewOffset: currentOffset,
                dataView: viewData,
                fileId: fileId,
                md5DataHash: null,
                // TODO: Calculate when the file is already in memory or in the
                // TODO: same cases as remote (e.g. blobs)
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
  FutureOr<String> interpretStateless(Map<String, dynamic> nav) =>
      nav.get('fileId');

  @override
  List<VisualNavigator> store(String result) => [];
}
