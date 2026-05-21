import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';
import 'package:antinote/src/models/news/question/answer/answer.dart';
import 'package:antinote/src/models/news/question/answer/type.dart';
import 'package:antinote/src/models/news/question/pick.dart';

final class NewsQuestion with VisualIdMixin {
  final String label;
  final String id;
  final int place;
  final int rank;
  final NewsQuestionAnswerType responseType;
  final String title;
  final String htmlText;
  final int responseSize;
  final bool withMaximum;
  final int maximumResponseCount;
  final List<Attachment> attachments;

  final List<NewsQuestionPick> picks;

  final NewsQuestionAnswer answer;

  const NewsQuestion({
    required this.label,
    required this.id,
    required this.place,
    required this.rank,
    required this.responseType,
    required this.title,
    required this.htmlText,
    required this.responseSize,
    required this.withMaximum,
    required this.maximumResponseCount,
    required this.attachments,
    required this.picks,
    required this.answer,
  });

  @override
  CacheType? get cacheType => .NEWS_QUESTION;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield responseType.id.byteVisualIdData();
    yield title.visualIdData();
    yield htmlText.visualIdData();
    yield responseSize.bytesVisualIdData();
    yield withMaximum.visualIdData();
    yield maximumResponseCount.bytesVisualIdData();
    yield* attachments.visualIdForEach();
    yield* picks.visualIdForEach();
  }

  @override
  List<VisualIdMixin> get toStore => [answer, ...attachments, ...picks];
}

extension AsNewsQuestion on MapJsonNavigator {
  NewsQuestion asNewsQuestion() {
    final responseType = NewsQuestionAnswerType.values.byId(
      get<int>('genreReponse'),
    );

    return NewsQuestion(
      label: get('L'),
      id: get('N'),
      place: get('P'),
      rank: get('rang'),
      responseType: responseType,
      title: get('titre'),
      htmlText: get('texte'),
      responseSize: get('tailleReponse'),
      withMaximum: get('avecMaximum'),
      maximumResponseCount: get('nombreReponsesMax'),
      attachments: getLM('listePiecesJointes').mapL((e) => e.asAttachment()),
      picks: getLM('listeChoix').mapL((e) => e.asNewsQuestionPick()),
      answer: go('reponse').asNewsQuestionAnswer(responseType),
    );
  }
}
