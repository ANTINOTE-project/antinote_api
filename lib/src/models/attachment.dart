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

sealed class Attachment with VisualIdMixin {
  final String title;
  final String id;

  factory Attachment.decode(MapJsonNavigator nav) {
    return switch (nav.get<int>('G')) {
      0 => LinkAttachment.decode(nav),
      1 => FileAttachment.decode(nav),
      2 => CustomFileAttachment.decode(nav),
      _ => throw UnimplementedError(),
    };
  }

  factory Attachment.decodeResource(
    NotebookResourceEntryType resourceType,
    MapJsonNavigator nav,
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

  Attachment({required this.title, required this.id}) {
    for (final possibleLocation in possibleExtensionLocation) {
      final fileExtension = extension(possibleLocation);

      if (fileExtension.isEmpty) continue;

      // The same file extensions as remote, with some added (mainly the ones
      // for OpenDocument)
      type = switch (fileExtension.substring(1)) {
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

      if (type != .other) break;
    }
  }

  late FileAttachmentType type;
}

class FileAttachment extends Attachment {
  FileAttachment({required super.title, required super.id});

  @override
  CacheType? get cacheType => .FILE_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
  }

  factory FileAttachment.decode(MapJsonNavigator nav) {
    return FileAttachment(title: nav.get('L'), id: nav.get('N'));
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

final class LinkAttachment extends Attachment {
  LinkAttachment({required super.title, required super.id, required this.url});

  @override
  CacheType? get cacheType => .LINK_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield url.visualIdData();
  }

  final String url;

  @override
  List<String> get possibleExtensionLocation => [url, title];

  factory LinkAttachment.decode(MapJsonNavigator nav) {
    return LinkAttachment(
      title: nav.get('L') ?? nav.get('url'),
      id: nav.get('N'),
      url: nav.get('url'),
    );
  }
}

final class SubmittedFileAttachment extends FileAttachment {
  SubmittedFileAttachment({
    required super.title,
    required super.id,
    required this.deadline,
  });

  @override
  CacheType? get cacheType => .SUBMITTED_FILE_ATTACHMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield deadline.millisecondsSinceEpoch.bytesVisualIdData();
  }

  final DateTime deadline;

  factory SubmittedFileAttachment.decode(MapJsonNavigator nav) {
    return SubmittedFileAttachment(
      title: nav.get('L'),
      id: nav.get('N'),
      deadline: nav.get('pourLe'),
    );
  }
}

final class CustomFileAttachment extends FileAttachment {
  CustomFileAttachment({required super.title, required super.id});

  factory CustomFileAttachment.decode(MapJsonNavigator nav) {
    return CustomFileAttachment(title: nav.get('L'), id: nav.get('N'));
  }
}

extension AsAttachment on MapJsonNavigator {
  Attachment asAttachment() => Attachment.decode(this);
}
