import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';
import 'package:antinote_api/src/models/theme.dart';

enum HomeworkRenderType implements EnumId {
  noRender(0, renderOnRemote: false),
  paperRender(1, renderOnRemote: false),
  remoteRender(2, renderOnRemote: true),
  kiosqueRender(3, renderOnRemote: true), // TODO: Figure out what this is.
  remoteAudioRecordingRender(4, renderOnRemote: true);

  @override
  final int id;
  final bool renderOnRemote;

  const HomeworkRenderType(this.id, {required this.renderOnRemote});
}

final class const HandedAssignment({
  required final String label,
  required final String id,
  required final int type,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) =>
      .new(label: nav.get('L'), id: nav.get('N'), type: nav.get('G'));

  @override
  CacheType? get cacheType => .HANDED_ASSIGNMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield type.byteVisualIdData();
  }
}

final class const Homework({
  required final String id,
  required final int? type,
  required final Subject subject,
  required final String description,
  required final int? order,
  required final DateTime deadlineDate,
  required final DateTime givenDate,
  required final int backgroundColor,
  required final int textColor,
  required final int difficultyLevel,
  required final double duration,
  required final List<Attachment> attachments,
  required final bool isDone,
  required final bool withRender,
  required final HomeworkRenderType assignmentToRenderType,
  required final bool canHandAssignment,
  required final HandedAssignment? handedAssignment,
  required final DateTime? assignmentHandedTime,
  required final String? assignmentCorrectionComment,
  required final bool withFormatting,
  required final String? publicName,
  required final String? notebookEntryId,
  required final String? lessonId,
  required final List<Theme> themes,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    type: nav.get('G'),
    subject: .decode(nav.eGetM(['matiere', 'Matiere'])!),
    description: nav.get('descriptif'),
    order: nav.get('ordre'),
    deadlineDate: nav.eGet(['pourLe', 'PourLe'])!,
    givenDate: nav.eGet(['donneLe', 'DonneLe'])!,
    backgroundColor: nav.get<String>('CouleurFond').asRGB(),
    textColor: nav.get<String?>('couleurTexte')?.asRGB() ?? 0xFFFFFFFF,
    difficultyLevel: nav.get('niveauDifficulte'),
    duration: nav.get('duree'),
    attachments: nav
        .eGetLM(['listeDocumentJoint', 'ListePieceJointe'])!
        .mapL((e) => .decode(e)),
    isDone: nav.getB('TAFFait'),
    withRender: nav.getB('avecRendu'),
    assignmentToRenderType: HomeworkRenderType.values.byId(
      nav.get('genreRendu') ?? 0,
      defaultValue: .noRender,
    ),
    canHandAssignment: nav.getB('peuRendre'),
    handedAssignment: nav
        .mGetM('documentRendu')
        ?.inn((value) => .decode(value)),
    assignmentHandedTime: nav.get('dateRendu'),
    assignmentCorrectionComment: nav.get<String?>('commentaireCorrige'),
    withFormatting: nav.getB('avecMiseEnForme'),
    publicName: nav.get('nomPublic'),
    notebookEntryId: nav.mGetM('cahierDeTextes')?.get('N'),
    lessonId: nav.mGetM('cours')?.get('N'),
    themes: nav.mGetLM('ListeThemes')?.mapL((e) => .decode(e)) ?? [],
  );

  @override
  CacheType? get cacheType => .HOMEWORK;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* subject.collectVisualIdData();
    yield description.visualIdData();
    yield deadlineDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield givenDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield backgroundColor.colorVisualIdData();
    yield textColor.colorVisualIdData();
    yield difficultyLevel.byteVisualIdData();
    yield duration.visualIdData();
    yield* attachments.visualIdForEach();
    yield withRender.visualIdData();
    yield assignmentToRenderType.id.byteVisualIdData();
    yield canHandAssignment.visualIdData();
    yield withFormatting.visualIdData();
    yield publicName?.visualIdData();
    yield* themes.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    .eGo(subject, fields: ['matiere', 'Matiere']),
    for (final (index, attachment) in attachments.indexed)
      .eIndexed(
        attachment,
        possibleFields: ['listeDocumentJoint', 'ListePieceJointe'],
        index: index,
      ),

    if (handedAssignment != null)
      .go(handedAssignment!, field: 'documentRendu'),
  ];
}
