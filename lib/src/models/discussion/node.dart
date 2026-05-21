import 'dart:math';
import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class MessageRecipient with VisualIdMixin {
  final String id;

  const MessageRecipient({required this.id});

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield id.visualIdData();
  }
}

extension AsMessageRecipient on MapJsonNavigator {
  MessageRecipient asMessageRecipient() {
    return MessageRecipient(id: get('N'));
  }
}

sealed class DiscussionNode with VisualIdMixin {
  final String id;
  final List<MessageRecipient> recipients;
  final bool isNotARecipient;
  final int depth;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* recipients.visualIdForEach();
    yield isNotARecipient.visualIdData();
    yield depth.byteVisualIdData();
    // We do not put children because we still want the visual id to stay the
    // same if a message is posted beneath it.
  }

  final List<DiscussionNode> children;

  const DiscussionNode({
    required this.id,
    required this.recipients,
    required this.isNotARecipient,
    required this.depth,
    required this.children,
  });
}

final class DiscussionMessageNode extends DiscussionNode {
  const DiscussionMessageNode({
    required super.id,
    required super.recipients,
    required super.isNotARecipient,
    required super.depth,
    required super.children,
  });

  @override
  CacheType? get cacheType => .DISCUSSION_NODE;
}

final class DiscussionRootNode extends DiscussionNode {
  final int messageCount;
  final String subject;
  final bool withResponse;
  final String messageIdForParticipants;
  final String? public;
  final int? publicCount;

  /// Null means the initiator is the current user.
  final String? initiator;
  final bool read;
  final String dateLabel;
  final DateTime parsedDateLabel;
  final bool closeable;
  final bool closed;
  final bool canEdit;

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

  const DiscussionRootNode({
    required super.id,
    required super.recipients,
    required super.isNotARecipient,
    required super.depth,
    required this.messageCount,
    required this.subject,
    required this.withResponse,
    required this.messageIdForParticipants,
    required this.public,
    required this.publicCount,
    required this.initiator,
    required this.read,
    required this.dateLabel,
    required this.parsedDateLabel,
    required this.closeable,
    required this.closed,
    required this.canEdit,
    required super.children,
  }); // TODO: Turn this into a DateTime
}

extension AsDiscussionNode on MapJsonNavigator {
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

  DiscussionRootNode asDiscussionRootNode(List<DiscussionNode> children) {
    final matchedDate =
        _dateLabelParser.firstMatch(get<String>('libelleDate')) ??
        _secondDateLabelParser.firstMatch(get<String>('libelleDate'));
    final DateTime parsedDate;

    if (matchedDate != null) {
      parsedDate = DateTime.utc(
        !matchedDate.groupNames.contains('year')
            ? DateTime.now().year
            : 2000 + int.parse(matchedDate.namedGroup('year')!),
        int.parse(matchedDate.namedGroup('month')!),
        int.parse(matchedDate.namedGroup('day')!),
      );
    } else {
      final matchedTime = _thirdDateLabelParser.firstMatch(
        get<String>('libelleDate'),
      );

      if (matchedTime != null) {
        parsedDate = DateTime.now().copyWith(
          isUtc: true,
          hour: int.tryParse(matchedTime.namedGroup('hour')!),
          minute: int.tryParse(matchedTime.namedGroup('minute')!),
        );
      } else {
        final matchedCombinaison = _fourthDateLabelParser.firstMatch(
          get<String>('libelleDate'),
        );

        if (matchedCombinaison == null) {
          // We fallback to now because this might make important messages sink to
          // the bottom of the discussion list if we set the date to epoch.
          parsedDate = DateTime.now().copyWith(isUtc: true);
        } else {
          // Trickiest to implement as to know which day it is, we need to match a localized weekday name to a date...
          // TODO: Add localization probably with intl
          final curAttempt = DateTime.now().copyWith(
            isUtc: true,
            hour: int.tryParse(matchedCombinaison.namedGroup('hour')!),
            minute: int.tryParse(matchedCombinaison.namedGroup('minute')!),
          );

          final weekDay = switch (matchedCombinaison.namedGroup('weekday')) {
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

    return DiscussionRootNode(
      id: get('N'),
      recipients: getLM(
        'listePossessionsMessages',
      ).mapL((e) => e.asMessageRecipient()),
      isNotARecipient: get('estNonPossede') ?? false,
      depth: get('profondeur'),
      messageCount: get('nombreMessages'),
      subject: get('objet'),
      withResponse: get('avecReponse') ?? false,
      messageIdForParticipants: go('messagePourParticipants').get('N'),
      public: get('public'),
      publicCount: get('nbPublic'),
      initiator: get('initiateur'),
      read: get('lu') ?? false,
      dateLabel: get('libelleDate'),
      parsedDateLabel: parsedDate,
      closeable: get('fermable') ?? false,
      closed: get('ferme') ?? false,
      canEdit: get('avecModifObjet') ?? false,
      children: children,
    );
  }

  DiscussionMessageNode asDiscussionMessageNode(List<DiscussionNode> children) {
    return DiscussionMessageNode(
      id: get('N'),
      recipients: getLM(
        'listePossessionsMessages',
      ).mapL((e) => e.asMessageRecipient()),
      isNotARecipient: get('estNonPossede'),
      depth: get('profondeur'),
      children: children,
    );
  }

  DiscussionNode asDiscussionNode(List<DiscussionNode> children) {
    if (get('estUneDiscussion') == true) {
      return asDiscussionRootNode(children);
    }

    return asDiscussionMessageNode(children);
  }
}

extension ListDiscussionRoots on ListJsonNavigator<MapJsonNavigator> {
  List<DiscussionRootNode> asDiscussionRootsList() {
    if (empty) return [];

    final biggestDepth = fold(
      0,
      (previousValue, element) => max(previousValue, element.get('profondeur')),
    );

    Map<int, List<DiscussionNode>> depthMaps = {};
    List<DiscussionRootNode> finalList = <DiscussionRootNode>[];

    for (int depth = biggestDepth; depth >= 0; depth--) {
      for (int nodeIndex = 0; nodeIndex < length; nodeIndex++) {
        final rawNode = get(nodeIndex);
        if (rawNode.get('profondeur') != depth) continue;

        final node = rawNode.asDiscussionNode(
          depthMaps.remove(nodeIndex) ?? [],
        );

        if (rawNode.has('indicePere')) {
          final parent = rawNode.get<int>('indicePere');
          if (depthMaps.containsKey(parent)) {
            depthMaps[parent]!.add(node);
          } else {
            depthMaps[parent] = [node];
          }
        } else {
          assert(
            node is DiscussionRootNode,
            'Only root nodes do not have parent indices.',
          );
          finalList.add(node as DiscussionRootNode);
        }
      }
    }

    return finalList;
  }
}
