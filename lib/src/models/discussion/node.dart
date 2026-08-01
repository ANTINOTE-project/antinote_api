import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const MessageRecipient({required final String id})
    with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(id: nav.get('N'));
  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield id.visualIdData();
  }
}

sealed class const DiscussionNode({
  required final String id,
  required final int index,
  required final List<MessageRecipient> recipients,
  required final bool isNotARecipient,
  required final int depth,

  required final List<DiscussionNode> children,
}) with VisualIdMixin {
  factory decode(
    int index,
    Map<String, dynamic> nav,
    List<DiscussionNode> children,
  ) => switch (nav) {
    _ when nav.getB('estUneDiscussion') => DiscussionRootNode.decode(
      index,
      nav,
      children,
    ),
    _ => DiscussionMessageNode.decode(index, nav, children),
  };

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* recipients.visualIdForEach();
    yield isNotARecipient.visualIdData();
    yield depth.byteVisualIdData();
    // We do not put children because we still want the visual id to stay the
    // same if a message is posted beneath it.
  }

  List<DiscussionNode> flatten() => [
    this,
    for (final child in children) ...child.flatten(),
  ];
}

final class const DiscussionMessageNode({
  required super.id,
  required super.index,
  required super.recipients,
  required super.isNotARecipient,
  required super.depth,
  required super.children,
}) extends DiscussionNode {
  factory decode(
    int index,
    Map<String, dynamic> nav,
    List<DiscussionNode> children,
  ) => .new(
    id: nav.get('N'),
    index: index,
    recipients: nav.getLM('listePossessionsMessages').mapL((e) => .decode(e)),
    isNotARecipient: nav.get('estNonPossede'),
    depth: nav.get('profondeur'),
    children: children,
  );

  @override
  CacheType? get cacheType => .DISCUSSION_NODE;
}

final class const DiscussionRootNode({
  required final int messageCount,
  required final String subject,
  required final bool withResponse,
  required final String messageIdForParticipants,
  required final String? public,
  required final int? publicCount,

  /// Null means the initiator is the current user.
  required final String? initiator,
  required final bool read,
  required final String dateLabel,
  required final DateTime parsedDateLabel,
  required final bool closeable,
  required final bool closed,
  required final bool canEdit,

  required super.id,
  required super.index,
  required super.recipients,
  required super.isNotARecipient,
  required super.depth,

  required super.children,
}) extends DiscussionNode {
  // Ex: 13/06/26
  static final _dateLabelParser = RegExp(
    r'(?<day>\d{2})/(?<month>\d{2})/(?<year>\d{2})',
  );

  // Ex: samedi 18/04
  static final _secondDateLabelParser = RegExp(
    r'\w+ (?<day>\d{2})/(?<month>\d{2})',
  );

  // Ex: jeudi 15h50
  static final _fourthDateLabelParser = RegExp(
    r'(?<weekday>\w+) (?<hour>\d{1,2})h(?<minute>\d{2})',
  );

  // Ex: 15h50
  static final _thirdDateLabelParser = RegExp(
    r'^(?<hour>\d{1,2})h(?<minute>\d{2})',
  );

  factory decode(
    int index,
    Map<String, dynamic> nav,
    List<DiscussionNode> children,
  ) {
    final matchedDate =
        _dateLabelParser.firstMatch(nav.get<String>('libelleDate')) ??
        _secondDateLabelParser.firstMatch(nav.get<String>('libelleDate'));
    final DateTime parsedDate;

    if (matchedDate != null) {
      parsedDate = DateTime.utc(
        !matchedDate.groupNames.contains('year')
            ? DateTime.now().year
            : 2000 + .parse(matchedDate.namedGroup('year')!),
        .parse(matchedDate.namedGroup('month')!),
        .parse(matchedDate.namedGroup('day')!),
      );
    } else {
      final matchedTime = _thirdDateLabelParser.firstMatch(
        nav.get<String>('libelleDate'),
      );

      if (matchedTime != null) {
        parsedDate = DateTime.now().copyWith(
          isUtc: true,
          hour: int.tryParse(matchedTime.namedGroup('hour')!),
          minute: int.tryParse(matchedTime.namedGroup('minute')!),
        );
      } else {
        final matchedCombination = _fourthDateLabelParser.firstMatch(
          nav.get<String>('libelleDate'),
        );

        if (matchedCombination == null) {
          // We fallback to now because this might make important messages sink to
          // the bottom of the discussion list if we set the date to epoch.
          parsedDate = DateTime.now().copyWith(isUtc: true);
        } else {
          // Trickiest to implement as to know which day it is, we need to match a localized weekday name to a date...
          // TODO: Add localization probably with intl
          final curAttempt = DateTime.now().copyWith(
            isUtc: true,
            hour: int.tryParse(matchedCombination.namedGroup('hour')!),
            minute: int.tryParse(matchedCombination.namedGroup('minute')!),
          );

          final weekDay = switch (matchedCombination.namedGroup('weekday')) {
            'lundi' => DateTime.monday,
            'mardi' => DateTime.tuesday,
            'mercredi' => DateTime.wednesday,
            'jeudi' => DateTime.thursday,
            'vendredi' => DateTime.friday,
            'samedi' => DateTime.saturday,
            'dimanche' => DateTime.sunday,
            _ => null,
          };

          if (weekDay != null) {
            parsedDate = curAttempt.subtract(
              Duration(days: (curAttempt.weekday - weekDay).abs()),
            );
          } else {
            parsedDate = curAttempt;
          }
        }
      }
    }

    return .new(
      id: nav.get('N'),
      index: index,
      recipients: nav.getLM('listePossessionsMessages').mapL((e) => .decode(e)),
      isNotARecipient: nav.get('estNonPossede') ?? false,
      depth: nav.get('profondeur'),
      messageCount: nav.get('nombreMessages'),
      subject: nav.get('objet'),
      withResponse: nav.get('avecReponse') ?? false,
      messageIdForParticipants: nav.go('messagePourParticipants').get('N'),
      public: nav.get('public'),
      publicCount: nav.get('nbPublic'),
      initiator: nav.get('initiateur'),
      read: nav.get('lu') ?? false,
      dateLabel: nav.get('libelleDate'),
      parsedDateLabel: parsedDate,
      closeable: nav.get('fermable') ?? false,
      closed: nav.get('ferme') ?? false,
      canEdit: nav.get('avecModifObjet') ?? false,
      children: children,
    );
  }

  @override
  CacheType? get cacheType => .DISCUSSION_NODE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield messageCount.byteVisualIdData();
    yield subject.visualIdData();
    yield withResponse.visualIdData();
    yield messageIdForParticipants.visualIdData();
    yield public?.visualIdData();
    yield publicCount?.bytesVisualIdData();
    yield initiator?.visualIdData();
    yield read.visualIdData();
    yield dateLabel.visualIdData();
    yield closeable.visualIdData();
    yield closed.visualIdData();
    yield canEdit.visualIdData();
  }
}
