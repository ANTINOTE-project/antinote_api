import 'dart:async';

import 'package:antinote_api/antinote_api.dart';
import 'package:antinote_api/src/models/state.dart';

final class const NewsUpdate({
  required final bool? read,
  required final bool? onlyMarkedRead,
  required final bool? deleted,
  required final Map<NewsQuestion, NewsQuestionAnswer> answersToChange,
});

final class const ChangeNewsStateAccessor({
  required final Map<News, NewsUpdate> updatesToPerform,
}) extends Accessor<void> {
  @override
  bool get exclusiveFriendly => false;

  @override
  int? get page => 8;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'SaisieActualites',
            dataSec: {
              session.stack.vocab.data: {
                // 0 is for actual updates, 1 is for off time news retrieval
                'genreSaisie': 0,
                'listeActualites': [
                  for (final MapEntry(key: news, value: updates)
                      in updatesToPerform.entries)
                    {
                      'estPublic': news.isPublic,
                      'genrePublic': news.recipientType,
                      'L': news.label,
                      // TODO: Create custom edit system that automagically
                      // TODO: figures out element states.
                      'E': news.isInformation
                          ? ElementState.edit
                          : ElementState.editChildren,
                      'listeQuestions': [
                        for (final MapEntry(key: baseQuestion, value: answer)
                            in updates.answersToChange.entries)
                          {
                            'N': baseQuestion.id,
                            'L': baseQuestion.label,
                            // TODO: Change this for news creation
                            'E': ElementState.edit,
                            'genreReponse': baseQuestion.responseType.id,
                            'reponse': {
                              'N': int.tryParse(answer.id) ?? answer.id,
                              'E': baseQuestion.answer.withAnswer
                                  ? ElementState.edit
                                  : ElementState.creation,
                              'avecReponse': answer.withAnswer,
                              'estReponseAttendue': answer.answerAwaited,
                              if (answer.withAnswer &&
                                  answer.responseValue != null)
                                'valeurReponse': answer.responseValue,
                              if (answer.withAnswer &&
                                  answer.freeResponseValue != null)
                                'valeurReponseLibre': answer.freeResponseValue,
                            },
                          },
                      ],
                      'lue': updates.read ?? news.read,
                      'marqueLueSeulement': updates.onlyMarkedRead ?? false,
                      'N': news.id,
                      'public': news.recipient.toJson(),
                      'saisieActualite': false,
                      'supprimee': updates.deleted ?? false,
                      'validationDirecte': true,
                    },
                ],
                'saisieActualite': false,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future;
  }

  @override
  FutureOr<void> interpret(Map<String, dynamic> nav, RemoteSession session) {
    assert(
      nav.mGetM('RapportSaisie')?.isNotEmpty ?? true,
      'Update request unsuccessful',
    );
  }

  @override
  List<VisualNavigator> store(void result) => [];
}
