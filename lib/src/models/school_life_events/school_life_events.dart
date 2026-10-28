library;

import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';

part 'absence.dart';
part 'delay.dart';
part 'dispense.dart';
part 'exclusion.dart';
part 'other.dart';

enum SchoolLifeEventType {
  absence /*13*/,
  retard /*14*/,
  exclusion /*71*/,
  dispense /*40*/,
  other /*46*/,
}

class SchoolLifeEventMessage {
  final String id;
  final DateTime? start;
  final DateTime? end;
  final List<SchoolLifeEventReason> reasons;

  const SchoolLifeEventMessage({
    required this.id,
    required this.start,
    required this.end,
    required this.reasons,
  });

  factory SchoolLifeEventMessage.decode(Map<String, dynamic> nav) {
    return SchoolLifeEventMessage(
      id: nav.get('N'),
      start: nav.get('dateDebut'),
      end: nav.get('dateFin'),
      reasons: nav.getLM('listeMotifs').mapL(SchoolLifeEventReason.decode),
    );
  }
}

sealed class const SchoolLifeEvent({
  required final String id,
  required final DateTime? start,
  required final DateTime? end,
  required final List<SchoolLifeEventReason> reasons,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    final message = SchoolLifeEventMessage.decode(nav);

    // This feels more and more like a hack...
    // TODO: Replace those objects with a modular system.
    return switch (nav) {
      {/*'G': 71, */ 'estUneExclusion': final isExclusion}
          when isExclusion == true =>
        Exclusion.decode(message, nav),
      {'G': 13} => Absence.decode(message, nav),
      {'G': 14} => Delay.decode(message, nav),
      {'G': 40} => Dispense.decode(message, nav),
      _ => Absence.decode(message, nav),
    };
  }

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT;

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, reason) in reasons.indexed)
      .indexed(reason, field: 'listeMotifs', index: index),
  ];
}

final class const SchoolLifeEventReason({
  required final String id,
  required final String name,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    return SchoolLifeEventReason(id: nav.get('N'), name: nav.get('L'));
  }

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT_REASON;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
  }
}
