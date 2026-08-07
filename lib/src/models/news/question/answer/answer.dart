import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/domain.dart';
import 'package:antinote_api/src/models/news/question/answer/type.dart';

sealed class const NewsQuestionAnswer({
  /// If [withAnswer] is true, this is the ID of the answer as a String, or else
  /// it is the answer to give when giving the answer as a String with an int
  /// inside of it, it's some kind of slot.
  required final String id,
  required final bool withAnswer,
  required final bool answerAwaited,
  required final DateTime? answeredOn,
  required final String? respondentFullName,
  required final bool? isRespondent,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerType type) {
    final message = NewsQuestionAnswerMessage.decode(nav);
    return switch (type) {
      .receiptAcknowledgment => RANewsQuestionAnswer.decode(nav, message),
      .withoutReceiptAcknowledgment => WithoutRANewsQuestionAnswer.decode(nav, message),
      .singleChoice => SingleChoiceNewsQuestionAnswer.decode(nav, message),
      .multipleChoices => MultipleChoiceNewsQuestionAnswer.decode(nav, message),
      .withoutResponse => NoResponseNewsQuestionAnswer.decode(nav, message),
      .textual => TextualResponseNewsQuestionAnswer.decode(nav, message),
    };
  }

  dynamic get responseValue;

  String? get freeResponseValue;

  @override
  CacheType? get cacheType => .NEWS_QUESTION_ANSWER;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield withAnswer.visualIdData();
    yield answerAwaited.visualIdData();
    yield answeredOn?.millisecondsSinceEpoch.bytesVisualIdData();
    yield respondentFullName?.visualIdData();
    yield isRespondent?.visualIdData();
  }
}

final class const RANewsQuestionAnswer({
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
}) extends NewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) =>
      .new(
        id: message.id,
        withAnswer: message.withAnswer,
        answerAwaited: message.answerAwaited,
        answeredOn: message.answeredOn,
        respondentFullName: message.respondentFullName,
        isRespondent: message.isRespondent,
      );

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => withAnswer ? '' : null;

  RANewsQuestionAnswer buildAnswered() {
    return .new(
      id: id,
      withAnswer: true,
      answerAwaited: answerAwaited,
      answeredOn: DateTime.now().copyWith(isUtc: true),
      respondentFullName: respondentFullName,
      isRespondent: isRespondent,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield withAnswer.visualIdData();
  }
}

final class const WithoutRANewsQuestionAnswer({
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
}) extends NewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) => .new(
    id: message.id,
    withAnswer: message.withAnswer,
    answerAwaited: message.answerAwaited,
    answeredOn: message.answeredOn,
    respondentFullName: message.respondentFullName,
    isRespondent: message.isRespondent,
  );

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield false.visualIdData();
  }
}

sealed class const ChoiceNewsQuestionAnswer({
  required final Set<int> answers,
  required final String? freeResponse,

  required final int responseMaxSize,

  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
}) extends NewsQuestionAnswer {
  @override
  String? get freeResponseValue => freeResponse;

  @override
  get responseValue => {'_T': 26, 'V': answers.asDomain()};

  ChoiceNewsQuestionAnswer buildAnswered(Set<int> picked, String? freeResponse);

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield answers.asDomain().visualIdData();
    yield freeResponse?.visualIdData();
  }
}

final class const SingleChoiceNewsQuestionAnswer({
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
  required super.answers,
  required super.freeResponse,
  required super.responseMaxSize,
}) extends ChoiceNewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) => .new(
    id: message.id,
    withAnswer: message.withAnswer,
    answerAwaited: message.answerAwaited,
    answeredOn: message.answeredOn,
    respondentFullName: message.respondentFullName,
    isRespondent: message.isRespondent,
    answers: nav.get('valeurReponse') ?? {},
    freeResponse: nav.get('valeurReponseLibre'),
    responseMaxSize: nav.get('tailleReponse') ?? 200,
  );

  int? get answer => answers.singleOrNull;

  @override
  SingleChoiceNewsQuestionAnswer buildAnswered(
    Set<int> picked,
    String? freeResponse,
  ) {
    return SingleChoiceNewsQuestionAnswer(
      id: id,
      withAnswer: true,
      answerAwaited: answerAwaited,
      answeredOn: DateTime.now().copyWith(isUtc: true),
      respondentFullName: respondentFullName,
      isRespondent: isRespondent,
      answers: picked,
      freeResponse: freeResponse,
      responseMaxSize: responseMaxSize,
    );
  }
}

final class const MultipleChoiceNewsQuestionAnswer({
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
  required super.answers,
  required super.freeResponse,
  required super.responseMaxSize,
}) extends ChoiceNewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) => .new(
    id: message.id,
    withAnswer: message.withAnswer,
    answerAwaited: message.answerAwaited,
    answeredOn: message.answeredOn,
    respondentFullName: message.respondentFullName,
    isRespondent: message.isRespondent,
    answers: nav.get('valeurReponse') ?? {},
    freeResponse: nav.get('valeurReponseLibre'),
    responseMaxSize: nav.get('tailleReponse') ?? 200,
  );

  @override
  MultipleChoiceNewsQuestionAnswer buildAnswered(
    Set<int> picked,
    String? freeResponse,
  ) {
    return MultipleChoiceNewsQuestionAnswer(
      id: id,
      withAnswer: true,
      answerAwaited: answerAwaited,
      answeredOn: DateTime.now().copyWith(isUtc: true),
      respondentFullName: respondentFullName,
      isRespondent: isRespondent,
      answers: picked,
      freeResponse: freeResponse,
      responseMaxSize: responseMaxSize,
    );
  }
}

final class const NoResponseNewsQuestionAnswer({
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
}) extends NewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) => .new(
    id: message.id,
    withAnswer: message.withAnswer,
    answerAwaited: message.answerAwaited,
    answeredOn: message.answeredOn,
    respondentFullName: message.respondentFullName,
    isRespondent: message.isRespondent,
  );

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => null;
}

final class const TextualResponseNewsQuestionAnswer({
  required final String answer,
  required final int responseMaxSize,
  required super.id,
  required super.withAnswer,
  required super.answerAwaited,
  required super.answeredOn,
  required super.respondentFullName,
  required super.isRespondent,
}) extends NewsQuestionAnswer {
  factory decode(Map<String, dynamic> nav, NewsQuestionAnswerMessage message) => .new(
    id: message.id,
    withAnswer: message.withAnswer,
    answerAwaited: message.answerAwaited,
    answeredOn: message.answeredOn,
    respondentFullName: message.respondentFullName,
    isRespondent: message.isRespondent,
    answer: nav.get('valeurReponse') ?? '',
    responseMaxSize: nav.get('tailleReponse') ?? 200,
  );

  @override
  String? get freeResponseValue => null;

  @override
  String get responseValue => answer;

  TextualResponseNewsQuestionAnswer buildAnswered(String response) {
    return TextualResponseNewsQuestionAnswer(
      id: id,
      withAnswer: true,
      answerAwaited: answerAwaited,
      answeredOn: DateTime.now().copyWith(isUtc: true),
      respondentFullName: respondentFullName,
      isRespondent: isRespondent,
      answer: response,
      responseMaxSize: responseMaxSize,
    );
  }
}

final class const NewsQuestionAnswerMessage({
  required final String id,
  required final bool withAnswer,
  required final bool answerAwaited,
  required final DateTime? answeredOn,
  required final String? respondentFullName,
  required final bool? isRespondent,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    withAnswer: nav.get('avecReponse'),
    answerAwaited: nav.get('estReponseAttendue'),
    answeredOn: nav.get('reponduLe'),
    respondentFullName: nav.get('strRepondant'),
    isRespondent: nav.get('estRepondant'),
  );
}

