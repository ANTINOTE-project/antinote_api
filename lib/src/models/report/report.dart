import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/report/mention.dart';
import 'package:antinote/src/models/report/service.dart';
import 'package:antinote/src/models/user/resource.dart';

import '../grades/grade.dart';
import 'appreciation.dart';
import 'display_information.dart';
import 'service_category.dart';

sealed class const BaseReport({required final bool canEdit}) {
  factory decode(Map<String, dynamic> nav) {
    if (nav.has('Message')) return UnpublishedReport.decode(nav);

    return PublishedReport.decode(nav);
  }
}

final class const UnpublishedReport({
  @override required final bool canEdit,
  required final String publishDateString,
}) implements BaseReport {
  factory decode(Map<String, dynamic> nav) => .new(
    canEdit: nav.getB('Editable'),
    publishDateString: nav.get('Message'),
  );
}

final class PublishedReport({
  @override required final bool canEdit,

  required final StudentClass clazz,

  required final ReportDisplayInformation displayInformation,

  required final List<ReportService> services,
  required final List<ServiceCategory> serviceCategories,

  required final bool serviceWithGradesExists,
  required final bool serviceWithoutGradesExists,

  required final Grade? studentAverage,
  required final Grade classAverage,

  required final String absenceString,
  required final String tardnessString,
  required final String punitionsString,
  required final String sanctionsString,

  required final Map<String, dynamic>? orientationData,
  required final List<dynamic>? attestationData,
  required final List<dynamic>? studentAttestationData,

  required final Person? student,
  required final int? studentSortOrder,

  required final bool canEditAppreciations,
  required final List<ReportAppreciation> appreciations,

  required final dynamic educativePathData,
  required final dynamic engagements,
  required final List<ReportMention>? possibleMentions,
  required final List<dynamic>? annotations,

  required final Uint8List? graph,

  required final Grade? defaultTheoreticalMaxGrade,
}) implements BaseReport {
  factory decode(Map<String, dynamic> nav) {
    final List<ServiceCategory> categories = nav
        .getLM('ListeSurMatieres')
        .mapL((e) => .decode(e));
    return .new(
      canEdit: nav.get('Editable'),
      clazz: .decode(nav.getM('Classe')),
      displayInformation: .decode(nav.getM('ParametresAffichages')),
      services: nav.getLM('ListeServices').mapL((e) => .decode(e, categories))
        ..sort((a, b) {
          final globalRank = a.regroupementRank.compareTo(b.regroupementRank);
          if (globalRank != 0) return globalRank;

          return a.rankWithinRegroupement.compareTo(b.rankWithinRegroupement);
        }),
      serviceCategories: categories,
      serviceWithGradesExists: nav.get('existeServiceAvecNotes'),
      serviceWithoutGradesExists: nav.get('existeServiceSansNotes'),
      studentAverage: nav.go('General').get('MoyenneEleve'),
      classAverage: nav.go('General').get('MoyenneClasse'),
      absenceString: nav.go('ListeAbsences').get('strAbsences'),
      tardnessString: nav.go('ListeAbsences').get('strRetards'),
      punitionsString: nav.go('ListeAbsences').get('strPunitions'),
      sanctionsString: nav.go('ListeAbsences').get('strSanctions'),
      orientationData: nav.mGo('Orientation'),
      attestationData: nav.mGetL('ListeAttestations'),
      studentAttestationData: nav.mGetL('listeAttestationsEleve'),
      student: nav.mGetM('eleve').inn((value) => .decode(value)),
      studentSortOrder: nav.mGo('eleve')?.get('P'),
      canEditAppreciations: nav.go('ObjetListeAppreciations').get('Editable'),
      appreciations: nav
          .go('ObjetListeAppreciations')
          .getLM('ListeAppreciations')
          .mapL((e) => .decode(e)),
      educativePathData: nav.get('ParcoursEducatif'),
      engagements: nav.get('listeEngagements'),
      possibleMentions: nav.mGetLM('listeMentions')?.mapL((e) => .decode(e)),
      annotations: nav.mGetL('listeAnnotations'),
      graph: nav.has('graphe')
          ? base64Decode(
              nav.get<String>('graphe').replaceAll(RegExp(r'[\r\n]'), ''),
            )
          : null,
      defaultTheoreticalMaxGrade: nav.get('baremeParDefaut'),
    );
  }
}
