import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/news/question/answer/type.dart';

sealed class NewsQuestionAnswer with VisualIdMixin {
  /// If [withAnswer] is true, this is the ID of the answer as a String, or else
  /// it is the answer to give when giving the answer as a String with an int
  /// inside of it, it's some kind of slot.
  final String id;
  final bool withAnswer;
  final bool answerAwaited;
  final DateTime? answeredOn;
  final String? respondentFullName;
  final bool? isRespondent;

  dynamic get responseValue;

  String? get freeResponseValue;

  const NewsQuestionAnswer({
    required this.id,
    required this.withAnswer,
    required this.answerAwaited,
    required this.answeredOn,
    required this.respondentFullName,
    required this.isRespondent,
  });

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

final class RANewsQuestionAnswer extends NewsQuestionAnswer {
  final bool answered;

  const RANewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
  }) : answered = withAnswer;

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => answered ? '' : null;

  RANewsQuestionAnswer buildAnswered() {
    return RANewsQuestionAnswer(
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
    yield answered.visualIdData();
  }
}

final class WithoutRANewsQuestionAnswer extends NewsQuestionAnswer {
  final bool answered;

  const WithoutRANewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
  }) : answered = false;

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield answered.visualIdData();
  }
}

sealed class ChoiceNewsQuestionAnswer extends NewsQuestionAnswer {
  final Set<int> answers;
  final String? freeResponse;

  const ChoiceNewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
    required this.answers,
    required this.freeResponse,
  });

  @override
  String? get freeResponseValue => freeResponse;

  @override
  get responseValue => {'_T': 26, 'V': answers.asDomain()};

  ChoiceNewsQuestionAnswer buildAnswered(
    final Set<int> picked,
    final String? freeResponse,
  );

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* super.collectVisualIdData();
    yield answers.asDomain().visualIdData();
    yield freeResponse?.visualIdData();
  }
}

final class SingleChoiceNewsQuestionAnswer extends ChoiceNewsQuestionAnswer {
  int? get answer => answers.singleOrNull;

  const SingleChoiceNewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
    required super.answers,
    required super.freeResponse,
  });

  @override
  SingleChoiceNewsQuestionAnswer buildAnswered(
    final Set<int> picked,
    final String? freeResponse,
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
    );
  }
}

final class MultipleChoiceNewsQuestionAnswer extends ChoiceNewsQuestionAnswer {
  const MultipleChoiceNewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
    required super.answers,
    required super.freeResponse,
  });

  @override
  MultipleChoiceNewsQuestionAnswer buildAnswered(
    final Set<int> picked,
    final String? freeResponse,
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
    );
  }
}

final class NoResponseNewsQuestionAnswer extends NewsQuestionAnswer {
  const NoResponseNewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
  });

  @override
  String? get freeResponseValue => null;

  @override
  get responseValue => null;
}

final class TextualResponseNewsQuestionAnswer extends NewsQuestionAnswer {
  const TextualResponseNewsQuestionAnswer({
    required super.id,
    required super.withAnswer,
    required super.answerAwaited,
    required super.answeredOn,
    required super.respondentFullName,
    required super.isRespondent,
    required this.answer,
  });

  final String answer;

  @override
  String? get freeResponseValue => null;

  @override
  String get responseValue => answer;

  TextualResponseNewsQuestionAnswer buildAnswered(final String response) {
    return TextualResponseNewsQuestionAnswer(
      id: id,
      withAnswer: true,
      answerAwaited: answerAwaited,
      answeredOn: DateTime.now().copyWith(isUtc: true),
      respondentFullName: respondentFullName,
      isRespondent: isRespondent,
      answer: response,
    );
  }
}

final class NewsQuestionAnswerMessage {
  final String id;
  final bool withAnswer;
  final bool answerAwaited;
  final DateTime? answeredOn;
  final String? respondentFullName;
  final bool? isRespondent;

  const NewsQuestionAnswerMessage({
    required this.id,
    required this.withAnswer,
    required this.answerAwaited,
    required this.answeredOn,
    required this.respondentFullName,
    required this.isRespondent,
  });
}

extension AsNewsQuestionAnswer on MapJsonNavigator {
  NewsQuestionAnswerMessage asNewsQuestionAnswerMessage() {
    return NewsQuestionAnswerMessage(
      id: get('N'),
      withAnswer: get('avecReponse'),
      answerAwaited: get('estReponseAttendue'),
      answeredOn: get('reponduLe'),
      respondentFullName: get('strRepondant'),
      isRespondent: get('estRepondant'),
    );
  }

  NewsQuestionAnswer asNewsQuestionAnswer(NewsQuestionAnswerType type) {
    final message = asNewsQuestionAnswerMessage();
    return switch (type) {
      .receiptAcknowledgment => asRANewsQuestionAnswer(message),
      .withoutReceiptAcknowledgment => asWithoutRANewsQuestionAnswer(message),
      .singleChoice => asSingleChoiceNewsQuestionAnswer(message),
      .multipleChoices => asMultipleChoiceNewsQuestionAnswer(message),
      .withoutResponse => asNoResponseNewsQuestionAnswer(message),
      .textual => asTextualResponseNewsQuestionAnswer(message),
    };
  }

  RANewsQuestionAnswer asRANewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return RANewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
    );
  }

  WithoutRANewsQuestionAnswer asWithoutRANewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return WithoutRANewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
    );
  }

  NoResponseNewsQuestionAnswer asNoResponseNewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return NoResponseNewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
    );
  }

  SingleChoiceNewsQuestionAnswer asSingleChoiceNewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return SingleChoiceNewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
      answers: get('valeurReponse') ?? {},
      freeResponse: get('valeurReponseLibre'),
    );
  }

  MultipleChoiceNewsQuestionAnswer asMultipleChoiceNewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return MultipleChoiceNewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
      answers: get('valeurReponse') ?? {},
      freeResponse: get('valeurReponseLibre'),
    );
  }

  TextualResponseNewsQuestionAnswer asTextualResponseNewsQuestionAnswer(
    NewsQuestionAnswerMessage message,
  ) {
    return TextualResponseNewsQuestionAnswer(
      id: message.id,
      withAnswer: message.withAnswer,
      answerAwaited: message.answerAwaited,
      answeredOn: message.answeredOn,
      respondentFullName: message.respondentFullName,
      isRespondent: message.isRespondent,
      answer: get('valeurReponse') ?? '',
    );
  }
}
