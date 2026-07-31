import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/resource/entry.dart';
import 'package:path/path.dart';

enum FileAttachmentType {
  text,
  pdf,
  archive,
  spreadsheet,
  image,
  audio,
  video,
  slides,
  geogebra,
  other,
}

sealed class Attachment({required final String title, required final String id})
    with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    return switch (nav.get<int>('G')) {
      0 => LinkAttachment.decode(nav),
      1 => FileAttachment.decode(nav),
      2 => CustomFileAttachment.decode(nav),
      _ => throw UnimplementedError(),
    };
  }

  factory decodeResource(
    NotebookResourceEntryType resourceType,
    Map<String, dynamic> nav,
  ) {
    return switch (resourceType) {
      .website => LinkAttachment.decode(nav),
      .attachedDocument => FileAttachment.decode(nav),
      .cloudDocument => LinkAttachment.decode(nav),
      .submittedWork => SubmittedFileAttachment.decode(nav),
      _ => throw UnimplementedError(),
    };
  }

  List<String> get possibleExtensionLocation => [title];

  late final FileAttachmentType type = () {
    for (final possibleLocation in possibleExtensionLocation) {
      final fileExtension = extension(possibleLocation);

      if (fileExtension.isEmpty) continue;

      // The same file extensions as remote, with some added (mainly the ones
      // for OpenDocument)
      final candidate = switch (fileExtension.substring(1)) {
        'doc' || 'docx' || 'txt' || 'odt' => FileAttachmentType.text,
        'pdf' => FileAttachmentType.pdf,
        'gzip' || 'zip' || 'rar' => FileAttachmentType.archive,
        'xls' || 'xlsx' || 'ods' => FileAttachmentType.spreadsheet,
        // dart format off
        'png' || 'mng' || 'tiff' ||
        'jpeg' || 'gif' || 'jpg' ||
        'webp' || 'bmp' || 'odi' => FileAttachmentType.image,
      // dart format on
        'mp3' || 'ogg' || 'wav' => FileAttachmentType.audio,
        'mp4' || 'mpeg' || 'avi' => FileAttachmentType.video,
        'ppt' || 'pptx' || 'odp' => FileAttachmentType.slides,
        'ggb' => FileAttachmentType.geogebra,
        _ => FileAttachmentType.other,
      };

      if (candidate != .other) return candidate;
    }

    return FileAttachmentType.other;
  }();
}

final class FileAttachment({required super.title, required super.id})
    extends Attachment {
  factory FileAttachment.decode(Map<String, dynamic> nav) =>
      .new(title: nav.get('L'), id: nav.get('N'));

  @override
  CacheType? get cacheType => .FILE_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
  }

  Future<Uri> getLinkToAttachment(
    RemoteSession session, {
    Map<String, dynamic>? extras,
  }) async {
    final payload = await session.stack.crypto.aesEncrypt(
      utf8.encode(jsonEncode({'N': id, 'Actif': true, ...?extras})),
    );

    final url = session.stack.baseUrl.replace(
      pathSegments: [
        ...session.stack.baseUrl.pathSegments,
        'FichiersExternes',
        payload.toHex(),
        Uri.encodeComponent(title),
      ],
      queryParameters: {
        ...session.stack.baseUrl.queryParameters,
        'Session': session.stack.sessionId.toString(),
      },
    );

    return url;
  }
}

final class LinkAttachment({
  required super.title,
  required super.id,
  required final String url,
}) extends Attachment {
  factory decode(Map<String, dynamic> nav) {
    return .new(
      title: nav.get('L') ?? nav.get('url'),
      id: nav.get('N'),
      url: nav.get('url'),
    );
  }

  @override
  CacheType? get cacheType => .LINK_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield url.visualIdData();
  }

  @override
  List<String> get possibleExtensionLocation => [url, title];
}

final class SubmittedFileAttachment({
  required super.title,
  required super.id,
  required final DateTime deadline,
}) extends FileAttachment {
  factory SubmittedFileAttachment.decode(Map<String, dynamic> nav) =>
      .new(title: nav.get('L'), id: nav.get('N'), deadline: nav.get('pourLe'));

  @override
  CacheType? get cacheType => .SUBMITTED_FILE_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield deadline.millisecondsSinceEpoch.bytesVisualIdData();
  }
}

final class CustomFileAttachment({required super.title, required super.id})
    extends FileAttachment {
  factory CustomFileAttachment.decode(Map<String, dynamic> nav) =>
      .new(title: nav.get('L'), id: nav.get('N'));
}
