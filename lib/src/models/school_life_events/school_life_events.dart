library;

import 'dart:typed_data';

import '../../../antinote.dart';

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

  factory SchoolLifeEventMessage.decode(MapJsonNavigator nav) {
    return SchoolLifeEventMessage(
      id: nav.get('N'),
      start: nav.get('dateDebut'),
      end: nav.get('dateFin'),
      reasons: nav.getLM('listeMotifs').mapL(SchoolLifeEventReason.decode),
    );
  }
}

sealed class SchoolLifeEvent with VisualIdMixin {
  final String id;
  final DateTime? start;
  final DateTime? end;
  final List<SchoolLifeEventReason> reasons;

  const SchoolLifeEvent({
    required this.id,
    required this.start,
    required this.end,
    required this.reasons,
  });

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT;

  @override
  List<VisualIdMixin> get toStore => [...reasons];
}

extension AsSchoolLifeEvent on MapJsonNavigator {
  SchoolLifeEventMessage asSchoolLifeEventMessage() {
    return SchoolLifeEventMessage.decode(this);
  }

  SchoolLifeEvent asSchoolLifeEvent() {
    final schoolLifeMessage = asSchoolLifeEventMessage();

    return switch (this) {
      {'G': final type, 'estUneExclusion': final isExclusion}
          when type == 71 || isExclusion != null =>
        Exclusion.decode(schoolLifeMessage, this),
      {'G': final type} when type == 13 => Absence.decode(
        schoolLifeMessage,
        this,
      ),
      {'G': final type} when type == 14 => Delay.decode(
        schoolLifeMessage,
        this,
      ),
      {'G': final type} when type == 40 => Dispense.decode(
        schoolLifeMessage,
        this,
      ),
      _ => Absence.decode(schoolLifeMessage, this),
    };
  }
}

class SchoolLifeEventReason with VisualIdMixin {
  final String id;
  final String name;

  const SchoolLifeEventReason({required this.id, required this.name});

  factory SchoolLifeEventReason.decode(MapJsonNavigator nav) {
    return SchoolLifeEventReason(id: nav.get('N'), name: nav.get('L'));
  }

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT_REASON;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
  }
}
