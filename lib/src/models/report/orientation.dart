import 'package:antinote/antinote.dart';

enum BoardOpinionType(
  @override final int id, {
  required final bool? yesNoMeaning,
}) implements EnumId {
  none(0, yesNoMeaning: null),
  veryFavorable(1, yesNoMeaning: true),
  favorable(2, yesNoMeaning: true),
  reserved(3, yesNoMeaning: false),
  unfavorable(4, yesNoMeaning: false)
}

enum OrientationSectionType(
  @override final int id, {
  final bool yesNoMode = false,
}) implements EnumId {
  familyWish(0),
  otherBoardRecommendation(1),
  definitiveWish(2, yesNoMode: true),
  otherBoardProposal(3),
  finalDecision(4),
  effectiveOrientation(5);
}

final class const OrientationWishOption({
  required final String label,
  required final String id,
  required final String code,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(label: nav.get('L'), id: nav.get('N'), code: nav.get('code'));
}

final class const OrientationWish({
  required final String id,
  required final int rank,
  required final OrientationStat stat,
  required final bool withFamilyGatewayInternship,
  required final List<OrientationWishOption> options,
  required final String comment,
  required final BoardOpinionType boardResponse,
  required final String motivation,
  required final bool withBoardGatewayInternship,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    rank: nav.get('rang'),
    stat: .decode(nav.getM('orientation')),
    withFamilyGatewayInternship: nav.getB('avecStagePasserelleFamille'),
    options: nav.getLM('listeOptions').mapL((e) => .decode(e)),
    comment: nav.get('commentaire'),
    boardResponse: .values.byId(nav.get('reponseCC')),
    motivation: nav.get('motivation'),
    withBoardGatewayInternship: nav.get('avecStagePasserelleConseil'),
  );
}

final class const OrientationSection({
  required final OrientationSectionType type,
  required final String label,

  required final List<OrientationWish>? wishes,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    type: .values.byId(nav.get('G')),
    label: nav.get('L'),
    wishes: nav.mGetLM('listeVoeux')?.mapL((e) => .decode(e)),
  );
}

final class const OrientationStat({
  required final String label,
  required final String id,
  required final Map<BoardOpinionType, int>? studentCounts,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    studentCounts: nav.has('nombreEleves')
        ? .fromEntries(
            nav
                .getL<int>('nombreEleves')
                .indexed
                .map((e) => .new(.values.byId(e.$1), e.$2)),
          )
        : null,
  );

  int get yesCount => studentCounts!.entries.fold(
    0,
    (previousValue, element) =>
        (element.key.yesNoMeaning == true ? element.value : 0) + previousValue,
  );

  int get noCount => studentCounts!.entries.fold(
    0,
    (previousValue, element) =>
        (element.key.yesNoMeaning == false ? element.value : 0) + previousValue,
  );

  int count(BoardOpinionType type) => studentCounts![type] ?? 0;
}

sealed class const OrientationData() {}

final class const ClassOrientationData({
  required final OrientationSection section,
  required final List<OrientationStat> orientations,
}) extends OrientationData {
  factory decode(Map<String, dynamic> nav) => .new(
    section: .decode(nav.getM('rubrique')),
    orientations: nav.getLM('listeOrientations').mapL((e) => .decode(e)),
  );
}

final class const StudentOrientationData({
  required final List<OrientationSection> sections,
}) extends OrientationData {
  factory decode(Map<String, dynamic> nav) =>
      .new(sections: nav.getLM('listeRubriques').mapL((e) => .decode(e)));
}
