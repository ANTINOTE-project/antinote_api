part of 'call.dart';

final class UploadCallData {
  final String orderId;
  final String fileName;
  final String? contentType;
  final int contentLength;
  final int viewOffset;
  final Uint8List dataView;
  final String fileId;
  final String? md5DataHash;
  final DateTime uploadStartTime;

  const UploadCallData({
    required this.orderId,
    required this.fileName,
    required this.contentType,
    required this.contentLength,
    required this.viewOffset,
    required this.dataView,
    required this.fileId,
    required this.md5DataHash,
    required this.uploadStartTime,
  });

  static String buildFileId(NetworkStack stack, String category) {
    final behavior = OrderBehavior.fileUpload(category);
    stack.nextOrder(behavior);
    return '${category}_${stack.order(behavior)}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Map<String, dynamic> asJson() => {
    'orderId': orderId,
    'fileName': fileName,
    'contentType': contentType,
    'contentLength': contentLength,
    'viewOffset': viewOffset,
    'dataView': dataView,
    'fileId': fileId,
    'md5DataHash': md5DataHash,
  };
}

extension AsUploadCallData on Map<String, dynamic> {
  UploadCallData asUploadCallData() {
    return UploadCallData(
      orderId: this['orderId'],
      fileName: this['fileName'],
      contentType: this['contentType'],
      contentLength: this['contentLength'],
      viewOffset: this['viewOffset'],
      dataView: this['dataView'],
      fileId: this['fileId'],
      md5DataHash: this['md5DataHash'],
      uploadStartTime: this['uploadStartTime'],
    );
  }
}

final class _FileUploadCall extends Call {
  // dart format off
  @override get callType => 'uploadfilesession';
  @override get orderBehavior => OrderBehavior.communication;
  @override get appendOrderToUrl => false;
  @override get addSignature => false;
  @override get dataSec => data.asJson();
  final UploadCallData data;
  @override final Completer<void> cancellationSignal;
  @override final String name;
  @override final Completer<Map<String, dynamic>> resultCompleter = Completer();
  @override final bool waitForResponse;
  // dart format on

  _FileUploadCall({
    required this.name,
    required this.data,
    this.waitForResponse = true,
    required Completer<void>? cancellationSignal,
  }) : cancellationSignal = cancellationSignal ?? Completer();

  @override
  Future<HttpClientRequest> serialize(
    NetworkStack stack,
    HttpClientRequest req,
    String orderId,
  ) async {
    // The capitalization isn't the right one, but it's the one PRONOTE uses.
    req.headers.add(
      'content-range',
      'bytes ${data.viewOffset}-${data.viewOffset + data.dataView.length - 1}/${data.contentLength}',
      preserveHeaderCase: true,
    );
    req.headers.add(
      'content-disposition',
      'attachment; filename="${Uri.encodeFull(data.fileName)}"',
      preserveHeaderCase: true,
    );
    final request = MultipartRequest('POST', Uri());
    request.fields.addAll({
      stack.vocab.fileUploadOrderNumber: orderId,
      stack.vocab.fileUploadSessionNumber: stack.sessionId.toString(),
      stack.vocab.fileUploadRequestId: name,
      stack.vocab.fileUploadFileId: data.fileId,
      stack.vocab.fileUploadMd5: data.md5DataHash ?? '',
    });
    request.files.addAll([
      MultipartFile.fromBytes(
        'files[]',
        data.dataView,
        filename: data.fileName,
        contentType: data.contentType == null
            ? null
            : MediaType.parse(data.contentType!),
      ),
    ]);

    final content = request.finalize();
    for (final header in request.headers.entries) {
      req.headers.add(header.key, header.value, preserveHeaderCase: true);
    }
    var totalLength = 0;
    await for (final chunk in content) {
      req.add(chunk);
      totalLength += chunk.length;
    }

    print("Total length is $totalLength");

    return req;
  }
}
