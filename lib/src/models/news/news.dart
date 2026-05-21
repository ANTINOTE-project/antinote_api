import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/news/category.dart';
import 'package:antinote/src/models/news/question/question.dart';
import 'package:antinote/src/models/person.dart';

final class News with VisualIdMixin {
  final String label;
  final String id;
  final bool anonymousResponse;
  final bool isInformation;
  final bool isPoll;
  final NewsCategory category;
  final bool read;
  final DateTime startDate;
  final DateTime endDate;
  final bool isProlonged;
  final DateTime creationTime;
  final String author;
  final bool isSelfAuthor;
  final Person authorProfile; // TODO: Find what elm means
  final String? recipientFirstName;
  final Person recipient;
  final int recipientType;

  final List<NewsQuestion> questions;

  const News({
    required this.label,
    required this.id,
    required this.anonymousResponse,
    required this.isInformation,
    required this.isPoll,
    required this.category,
    required this.read,
    required this.startDate,
    required this.endDate,
    required this.isProlonged,
    required this.creationTime,
    required this.author,
    required this.isSelfAuthor,
    required this.authorProfile,
    required this.recipientFirstName,
    required this.recipient,
    required this.recipientType,
    required this.questions,
  });

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

extension AsNews on MapJsonNavigator {
  News asNews() {
    return News(
      label: get('L'),
      id: get('N'),
      anonymousResponse: get('reponseAnonyme'),
      isInformation: get('estInformation'),
      isPoll: get('estSondage'),
      category: getM('categorie').asNewsCategory(),
      read: get('lue'),
      startDate: get('dateDebut'),
      endDate: get('dateFin'),
      isProlonged: get('estProlonge'),
      creationTime: get('dateCreation'),
      author: get('auteur'),
      isSelfAuthor: get('estAuteur'),
      authorProfile: getM('elmauteur').asPerson(),
      recipientFirstName: get('prenom'),
      recipient: getM('public').asPerson(),
      recipientType: get('genrePublic'),
      questions: getLM('listeQuestions').mapL((e) => e.asNewsQuestion()),
    );
  }
}
