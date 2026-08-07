import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/news/category.dart';
import 'package:antinote_api/src/models/news/question/question.dart';
import 'package:antinote_api/src/models/person.dart';

final class const NewsPreviewData({
  required final bool withAttachments,
  required final bool fullyAnswered,
  required final bool canEditResponse,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    withAttachments: nav.getB('avecPJ'),
    fullyAnswered: nav.getB('aToutRepondu'),
    canEditResponse: nav.getB('avecCommandeVisuResultat'),
  );
}

final class const News({
  required final String label,
  required final String id,
  required final bool anonymousResponse,
  required final bool isInformation,
  required final bool isPoll,
  required final NewsCategory? category,
  required final bool read,
  required final DateTime startDate,
  required final DateTime endDate,
  required final bool isProlonged,
  required final DateTime creationTime,
  required final String author,
  required final bool isSelfAuthor,
  required final Person authorProfile,
  required final String? recipientFirstName,
  required final Person recipient,
  required final int recipientType,
  required final bool isPublic,
  required final bool isShared,

  required final NewsPreviewData? previewData,

  required final List<NewsQuestion>? questions,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    anonymousResponse: nav.getB('reponseAnonyme'),
    isInformation: nav.getB('estInformation'),
    isPoll: nav.getB('estSondage'),
    category: nav.eGetM(['categorie', 'nature']).inn((e) => .decode(e)),
    read: nav.getB('lue'),
    startDate: nav.get('dateDebut'),
    endDate: nav.get('dateFin'),
    isProlonged: nav.getB('estProlonge'),
    creationTime: nav.get('dateCreation'),
    author: nav.get('auteur'),
    isSelfAuthor: nav.getB('estAuteur'),
    authorProfile: .decode(nav.getM('elmauteur')),
    recipientFirstName: nav.get('prenom'),
    recipient: .decode(nav.getM('public')),
    recipientType: nav.get('genrePublic'),
    // Tricky situation, on earlier versions this does not exist (and thus is
    // always true), but this could be false on newer versions (and thus
    // missing). We try to prioritise new versions.
    isPublic: nav.getB('estPublic'),
    isShared: nav.getB('estPartage'),

    previewData: nav.mGetM('informationListeContenu')?.inn((e) => .decode(e)),
    questions: nav.mGetLM('listeQuestions')?.mapL((e) => .decode(e)),
  );

  @override
  CacheType? get cacheType => .NEWS;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield anonymousResponse.visualIdData();
    yield isInformation.visualIdData();
    yield isPoll.visualIdData();
    yield* category?.collectVisualIdData() ?? [];
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield isProlonged.visualIdData();
    yield creationTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield author.visualIdData();
    yield isSelfAuthor.visualIdData();
    yield* authorProfile.collectVisualIdData();
    yield recipientFirstName?.visualIdData();
    yield* recipient.collectVisualIdData();
    yield recipientType.byteVisualIdData();
  }

  @override
  List<VisualNavigator> get toStore => [
    if (category != null) .eGo(category!, fields: ['categorie', 'nature']),
    .go(authorProfile, field: 'elmauteur'),
    .go(recipient, field: 'public'),

    if (questions != null)
      for (final (index, question) in questions!.indexed)
        .indexed(question, field: 'listeQuestions', index: index),
  ];
}
