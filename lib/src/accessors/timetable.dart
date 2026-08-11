import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/timetable.dart';
import 'package:antinote_api/src/models/user/resource.dart';

final class const TimetableAccessor({
  required final UserResource resource,
  required final Map<String, dynamic> extra,
}) extends Accessor<Timetable> {
  factory TimetableAccessor.forRange({
    required UserResource resource,
    required DateTime from,
    required DateTime? to,
  }) {
    return TimetableAccessor(
      resource: resource,
      extra: {
        ...propertyCaseInsensitive('dateDebut', from),
        if (to != null) ...propertyCaseInsensitive('dateFin', to),
      },
    );
  }

  factory TimetableAccessor.forDay({
    required UserResource resource,
    required DateTime day,
  }) => TimetableAccessor.forRange(resource: resource, from: day, to: null);

  factory TimetableAccessor.forWeek({
    required UserResource resource,
    required int week,
  }) {
    return TimetableAccessor(
      resource: resource,
      extra: propertyCaseInsensitive('numeroSemaine', week),
    );
  }

  factory TimetableAccessor.forYear({
    required UserResource resource,
    required RemoteSession session,
  }) {
    return TimetableAccessor.forRange(
      resource: resource,
      from: session.instance.firstDate,
      to: session.instance.lastDate,
    );
  }

  @override
  bool get exclusiveFriendly => true;

  static const int pageId = 16;

  @override
  // There are plenty pages that use this request, but since we currently only
  // support the student session, we keep only one page.
  int? get page => TimetableAccessor.pageId;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: "PageEmploiDuTemps",
            dataSec: {
              session.stack.vocab.data: {
                'estEDTPermanence': false,
                'avecAbsencesEleve': false,
                'avecRessourcesLibrePiedHoraire': false,
                'avecAbsencesRessource': true,
                'avecInfoPrefsGrille': true,
                'avecConseilDeClasse': true,
                'avecCoursSortiePeda': true,
                'avecDisponibilites': true,
                'avecRetenuesEleve': true,
                'edt': {'G': 16, 'L': 'Emploi du temps'},
                ...propertyCaseInsensitive('ressource', resource.toRaw()),
                ...extra,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<Timetable> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav, session);

  @override
  List<VisualNavigator> store(Timetable result) => [.stay(result)];
}
