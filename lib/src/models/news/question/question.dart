import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';
import 'package:antinote/src/models/news/question/answer/answer.dart';
import 'package:antinote/src/models/news/question/answer/type.dart';
import 'package:antinote/src/models/news/question/pick.dart';

final class const NewsQuestion({
  required final String label,
  required final String id,
  required final int place,
  required final int rank,
  required final NewsQuestionAnswerType responseType,
  required final String title,
  required final String htmlText,
  required final int responseSize,
  required final bool withMaximum,
  required final int maximumResponseCount,
  required final List<Attachment> attachments,

  required final List<NewsQuestionPick> picks,

  required final NewsQuestionAnswer answer,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    final responseType = NewsQuestionAnswerType.values.byId(
      nav.get<int>('genreReponse'),
    );

    return .new(
      label: nav.get('L'),
      id: nav.get('N'),
      place: nav.get('P'),
      rank: nav.get('rang'),
      responseType: responseType,
      title: nav.get('titre'),
      htmlText: nav.get('texte'),
      responseSize: nav.get('tailleReponse'),
      withMaximum: nav.get('avecMaximum'),
      maximumResponseCount: nav.get('nombreReponsesMax'),
      attachments: nav.getLM('listePiecesJointes').mapL((e) => .decode(e)),
      picks: nav.getLM('listeChoix').mapL((e) => .decode(e)),
      answer: .decode(nav.go('reponse'), responseType),
    );
  }

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
