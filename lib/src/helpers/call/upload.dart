part of 'call.dart';

final class const UploadCallData({
  required final String orderId,
  required final String fileName,
  required final String? contentType,
  required final int contentLength,
  required final int viewOffset,
  required final Uint8List dataView,
  required final String fileId,
  required final String? md5DataHash,
  required final DateTime uploadStartTime,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    orderId: nav.get('orderId'),
    fileName: nav.get('fileName'),
    contentType: nav.get('contentType'),
    contentLength: nav.get('contentLength'),
    viewOffset: nav.get('viewOffset'),
    dataView: nav.get('dataView'),
    fileId: nav.get('fileId'),
    md5DataHash: nav.get('md5DataHash'),
    uploadStartTime: nav.get('uploadStartTime'),
  );

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
    String orderId, {
    bool debugMode = false,
  }) async {
    // The capitalization isn't the right one, but it's the one remote uses.
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

    return req;
  }
}
