import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/timetable.dart';
import 'package:antinote/src/models/user/resource.dart';

final class const TimetableAccessor({
  required final UserResource resource,
  required final Map<String, dynamic> extra,
}) extends StatefulAccessor<Timetable, RemoteSession> {
  factory TimetableAccessor.forRange({
    required UserResource resource,
    required DateTime from,
    required DateTime? to,
  }) {
    return TimetableAccessor(
      resource: resource,
      extra: {
        ...propertyCaseInsensitive('dateDebut', {
          '_T': 7,
          'V': from.asRemoteDate(),
        }),
        if (to != null)
          ...propertyCaseInsensitive('dateFin', {
            '_T': 7,
            'V': to.asRemoteDate(),
          }),
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

  @override
  // There are plenty pages that use this request, but since we currently only
  // support the student session, we keep only one page.
  int? get page => 16;

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
  FutureOr<RemoteSession> collectState(RemoteSession session) => session;

  @override
  FutureOr<Timetable> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav, session);

  @override
  List<VisualNavigator> store(Timetable result) => [.stay(result)];
}
