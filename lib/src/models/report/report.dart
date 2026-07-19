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

sealed class BaseReport {
  final bool canEdit;

  const BaseReport({required this.canEdit});
}

extension AsReport on MapJsonNavigator {
  BaseReport asReport() {
    if (has('Message')) return asUnpublishedReport();

    return asPublishedReport();
  }
}

final class UnpublishedReport implements BaseReport {
  @override
  final bool canEdit;
  final String publishDateString;

  const UnpublishedReport({
    required this.canEdit,
    required this.publishDateString,
  });
}

extension AsUnpublishedReport on MapJsonNavigator {
  UnpublishedReport asUnpublishedReport() {
    return UnpublishedReport(
      canEdit: getB('Editable'),
      publishDateString: get('Message'),
    );
  }
}

final class PublishedReport implements BaseReport {
  @override
  final bool canEdit;

  final StudentClass clazz;

  final ReportDisplayInformation displayInformation;

  final List<ReportService> services;
  final List<ServiceCategory> serviceCategories;

  final bool serviceWithGradesExists;
  final bool serviceWithoutGradesExists;

  final Grade? studentAverage;
  final Grade classAverage;

  final String absenceString;
  final String tardnessString;
  final String punitionsString;
  final String sanctionsString;

  final Map<String, dynamic>? orientationData;
  final List<dynamic>? attestationData;
  final List<dynamic>? studentAttestationData;

  final Person? student;
  final int? studentSortOrder;

  final bool canEditAppreciations;
  final List<ReportAppreciation> appreciations;

  final dynamic educativePathData;
  final dynamic engagements;
  final List<ReportMention>? possibleMentions;
  final List<dynamic>? annotations;

  final Uint8List? graph;

  final Grade? defaultTheoreticalMaxGrade;

  const PublishedReport({
    required this.canEdit,
    required this.clazz,
    required this.displayInformation,
    required this.services,
    required this.serviceCategories,
    required this.serviceWithGradesExists,
    required this.serviceWithoutGradesExists,
    required this.studentAverage,
    required this.classAverage,
    required this.absenceString,
    required this.tardnessString,
    required this.punitionsString,
    required this.sanctionsString,
    required this.orientationData,
    required this.attestationData,
    required this.studentAttestationData,
    required this.student,
    required this.studentSortOrder,
    required this.canEditAppreciations,
    required this.appreciations,
    required this.educativePathData,
    required this.engagements,
    required this.possibleMentions,
    required this.annotations,
    required this.graph,
    required this.defaultTheoreticalMaxGrade,
  });
}

extension AsPublishedReport on MapJsonNavigator {
  PublishedReport asPublishedReport() {
    final categories = getLM(
      'ListeSurMatieres',
    ).mapL((e) => e.asServiceCategory());
    return PublishedReport(
      canEdit: get('Editable'),
      clazz: getM('Classe').asStudentClass(),
      displayInformation: getM(
        'ParametresAffichages',
      ).asReportDisplayInformation(),
      services:
          getLM(
            'ListeServices',
          ).mapL((e) => e.asReportService(categories))..sort((a, b) {
            final globalRank = a.regroupementRank.compareTo(b.regroupementRank);
            if (globalRank != 0) return globalRank;

            return a.rankWithinRegroupement.compareTo(b.rankWithinRegroupement);
          }),
      serviceCategories: categories,
      serviceWithGradesExists: get('existeServiceAvecNotes'),
      serviceWithoutGradesExists: get('existeServiceSansNotes'),
      studentAverage: go('General').get('MoyenneEleve'),
      classAverage: go('General').get('MoyenneClasse'),
      absenceString: go('ListeAbsences').get('strAbsences'),
      tardnessString: go('ListeAbsences').get('strRetards'),
      punitionsString: go('ListeAbsences').get('strPunitions'),
      sanctionsString: go('ListeAbsences').get('strSanctions'),
      orientationData: mGo('Orientation'),
      attestationData: mGetL('ListeAttestations'),
      studentAttestationData: mGetL('listeAttestationsEleve'),
      student: mGetM('eleve')?.asPerson(),
      studentSortOrder: mGo('eleve')?.get('P'),
      canEditAppreciations: go('ObjetListeAppreciations').get('Editable'),
      appreciations: go(
        'ObjetListeAppreciations',
      ).getLM('ListeAppreciations').mapL((e) => e.asReportAppreciation()),
      educativePathData: get('ParcoursEducatif'),
      engagements: get('listeEngagements'),
      possibleMentions: mGetLM(
        'listeMentions',
      )?.mapL((e) => e.asReportMention()),
      annotations: mGetL('listeAnnotations'),
      graph: has('graphe')
          ? base64Decode(
              get<String>('graphe').replaceAll(RegExp(r'[\r\n]'), ''),
            )
          : null,
      defaultTheoreticalMaxGrade: get('baremeParDefaut'),
    );
  }
}
