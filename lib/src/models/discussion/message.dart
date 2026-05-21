import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';

final class DiscussionMessage with VisualIdMixin {
  final String id;
  final String? sourceMessageId;
  final String messageRecipient;
  final bool isNotARecipient;
  final String content;
  final bool isHTML;
  final String dateLabel;
  final DateTime date;
  final bool isAnAparte;
  final bool isSelfCreator;
  final String leftPublic;
  final String? leftHint;
  final String? rightPublic;
  final String? rightHint;
  final int publicCount;
  final List<Attachment> attachments;

  const DiscussionMessage({
    required this.id,
    required this.sourceMessageId,
    required this.messageRecipient,
    required this.isNotARecipient,
    required this.content,
    required this.isHTML,
    required this.dateLabel,
    required this.date,
    required this.isAnAparte,
    required this.isSelfCreator,
    required this.leftPublic,
    required this.leftHint,
    required this.rightPublic,
    required this.rightHint,
    required this.publicCount,
    required this.attachments,
  });

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

extension AsDiscussionMessage on MapJsonNavigator {
  DiscussionMessage asDiscussionMessage() {
    return DiscussionMessage(
      id: get('N'),
      sourceMessageId: go('messageSource').get('N'),
      messageRecipient: go('possessionMessage').get('N'),
      isNotARecipient: get('estNonPossede'),
      content: get('contenu'),
      isHTML: get('estHTML'),
      dateLabel: get('libelleDate'),
      date: get('date'),
      isAnAparte: get('estUnAparte'),
      isSelfCreator: get('emetteur'),
      leftPublic: get('public_gauche'),
      leftHint: get('hint_gauche'),
      rightPublic: get('public_droite'),
      rightHint: get('hint_droite'),
      publicCount: get('nbPublic') ?? 1,
      attachments:
          mGetLM('listeDocumentsJoints')?.mapL((e) => e.asAttachment()) ?? [],
    );
  }
}
