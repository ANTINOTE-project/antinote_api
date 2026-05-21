import 'dart:typed_data';

import 'package:antinote/antinote.dart';
import 'package:antinote/src/models/theme.dart';

enum HomeworkRenderType implements EnumId {
  noRender(0, renderOnPronote: false),
  paperRender(1, renderOnPronote: false),
  pronoteRender(2, renderOnPronote: true),
  kiosqueRender(3, renderOnPronote: true), // TODO: Figure out what this is.
  pronoteAudioRecordingRender(4, renderOnPronote: true);

  @override
  final int id;
  final bool renderOnPronote;

  const HomeworkRenderType(this.id, {required this.renderOnPronote});
}

final class HandedAssignment with VisualIdMixin {
  final String label;
  final String id;
  final int type;

  const HandedAssignment({
    required this.label,
    required this.id,
    required this.type,
  });

  @override
  CacheType? get cacheType => .HANDED_ASSIGNMENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield type.byteVisualIdData();
  }
}

extension AsHandedAssignment on MapJsonNavigator {
  HandedAssignment asHandedAssignment() {
    return HandedAssignment(label: get('L'), id: get('N'), type: get('G'));
  }
}

final class Homework with VisualIdMixin {
  final String id;
  final int? type;
  final Subject subject;
  final String description;
  final int? order;
  final DateTime deadlineDate;
  final DateTime givenDate;
  final int backgroundColor;
  final int textColor;
  final int difficultyLevel;
  final double duration;
  final List<Attachment> attachments;
  final bool isDone;
  final bool withRender;
  final HomeworkRenderType assignmentToRenderType;
  final bool canHandAssignment;
  final HandedAssignment? handedAssignment;
  final DateTime? assignmentHandedTime;
  final String? assignmentCorrectionComment;
  final bool withFormatting;
  final String? publicName;
  final String? notebookEntryId;
  final String? lessonId;
  final List<Theme> themes;

  const Homework({
    required this.id,
    required this.type,
    required this.subject,
    required this.description,
    required this.order,
    required this.deadlineDate,
    required this.givenDate,
    required this.backgroundColor,
    required this.textColor,
    required this.difficultyLevel,
    required this.duration,
    required this.attachments,
    required this.isDone,
    required this.withRender,
    required this.assignmentToRenderType,
    required this.canHandAssignment,
    required this.handedAssignment,
    required this.assignmentHandedTime,
    required this.assignmentCorrectionComment,
    required this.withFormatting,
    required this.publicName,
    required this.notebookEntryId,
    required this.lessonId,
    required this.themes,
  });

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
  List<VisualIdMixin> get toStore => [
    subject,
    ...attachments,
    ?handedAssignment,
  ];
}

extension AsHomework on MapJsonNavigator {
  Homework asHomework() {
    return Homework(
      id: get('N'),
      type: get('G'),
      subject: eGetM(['matiere', 'Matiere'])!.asSubject(),
      description: get('descriptif'),
      order: get('ordre'),
      deadlineDate: eGet(['pourLe', 'PourLe'])!,
      givenDate: eGet(['donneLe', 'DonneLe'])!,
      backgroundColor: get<String>('CouleurFond').asRGB(),
      textColor: (get<String?>('couleurTexte') ?? 'ffffff').asRGB(),
      difficultyLevel: get('niveauDifficulte'),
      duration: get('duree'),
      attachments: eGetLM([
        'listeDocumentJoint',
        'ListePieceJointe',
      ])!.mapL((e) => e.asAttachment()),
      isDone: get('TAFFait'),
      withRender: get<bool?>('avecRendu') ?? false,
      assignmentToRenderType: HomeworkRenderType.values.byId(
        get('genreRendu') ?? 0,
        defaultValue: .noRender,
      ),
      canHandAssignment: get<bool?>('peuRendre') ?? false,
      handedAssignment: mGetM('documentRendu')?.asHandedAssignment(),
      assignmentHandedTime: get('dateRendu'),
      assignmentCorrectionComment: get<String?>('commentaireCorrige'),
      withFormatting: get('avecMiseEnForme') ?? false,
      publicName: get('nomPublic'),
      notebookEntryId: mGetM('cahierDeTextes')?.get('N'),
      lessonId: mGetM('cours')?.get('N'),
      themes: mGetLM('ListeThemes')?.mapL((e) => e.asTheme()) ?? [],
    );
  }
}
