import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/news/category.dart';
import 'package:antinote/src/models/news/question/question.dart';
import 'package:antinote/src/models/person.dart';

final class const News({
  required final String label,
  required final String id,
  required final bool anonymousResponse,
  required final bool isInformation,
  required final bool isPoll,
  required final NewsCategory category,
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

  required final List<NewsQuestion> questions,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    anonymousResponse: nav.get('reponseAnonyme'),
    isInformation: nav.get('estInformation'),
    isPoll: nav.get('estSondage'),
    category: .decode(nav.getM('categorie')),
    read: nav.get('lue'),
    startDate: nav.get('dateDebut'),
    endDate: nav.get('dateFin'),
    isProlonged: nav.get('estProlonge'),
    creationTime: nav.get('dateCreation'),
    author: nav.get('auteur'),
    isSelfAuthor: nav.get('estAuteur'),
    authorProfile: .decode(nav.getM('elmauteur')),
    recipientFirstName: nav.get('prenom'),
    recipient: .decode(nav.getM('public')),
    recipientType: nav.get('genrePublic'),
    questions: nav.getLM('listeQuestions').mapL((e) => .decode(e)),
  );

  @override
  CacheType? get cacheType => .NEWS;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield anonymousResponse.visualIdData();
    yield isInformation.visualIdData();
    yield isPoll.visualIdData();
    yield* category.collectVisualIdData();
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
  List<VisualIdMixin> get toStore => [
    category,
    authorProfile,
    recipient,
    ...questions,
  ];
}
