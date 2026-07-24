import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';

final class const DiscussionMessage({
  required final String id,
  required final String? sourceMessageId,
  required final String messageRecipient,
  required final bool isNotARecipient,
  required final String content,
  required final bool isHTML,
  required final String dateLabel,
  required final DateTime date,
  required final bool isAnAparte,
  required final bool isSelfCreator,
  required final String leftPublic,
  required final String? leftHint,
  required final String? rightPublic,
  required final String? rightHint,
  required final int publicCount,
  required final List<Attachment> attachments,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    sourceMessageId: nav.go('messageSource').get('N'),
    messageRecipient: nav.go('possessionMessage').get('N'),
    isNotARecipient: nav.get('estNonPossede'),
    content: nav.get('contenu'),
    isHTML: nav.get('estHTML'),
    dateLabel: nav.get('libelleDate'),
    date: nav.get('date'),
    isAnAparte: nav.get('estUnAparte'),
    isSelfCreator: nav.get('emetteur'),
    leftPublic: nav.get('public_gauche'),
    leftHint: nav.get('hint_gauche'),
    rightPublic: nav.get('public_droite'),
    rightHint: nav.get('hint_droite'),
    publicCount: nav.get('nbPublic') ?? 1,
    attachments:
        nav.mGetLM('listeDocumentsJoints')?.mapL((e) => .decode(e)) ?? [],
  );

  @override
  CacheType? get cacheType => .DISCUSSION_MESSAGE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield messageRecipient.visualIdData();
    yield isNotARecipient.visualIdData();
    yield content.visualIdData();
    yield isHTML.visualIdData();
    yield dateLabel.visualIdData();
    yield date.millisecondsSinceEpoch.bytesVisualIdData();
    yield isAnAparte.visualIdData();
    yield isSelfCreator.visualIdData();
    yield leftPublic.visualIdData();
    yield leftHint?.visualIdData();
    yield rightPublic?.visualIdData();
    yield rightHint?.visualIdData();
    yield publicCount.bytesVisualIdData();
    yield* attachments.visualIdForEach();
  }

  @override
  List<VisualIdMixin> get toStore => [...attachments];
}
