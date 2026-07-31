import 'dart:async';

import 'package:antinote/antinote.dart';
import 'package:antinote/src/models/state.dart';

final class const NewsUpdate({
  required final bool? read,
  required final bool? onlyMarkedRead,
  required final bool? deleted,
  required final Map<NewsQuestion, NewsQuestionAnswer> answersToChange,
});

final class const ChangeNewsStateAccessor({
  required final Map<News, NewsUpdate> updatesToPerform,
}) extends StatelessAccessor<void> {
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
                'listeActualites': [
                  for (final MapEntry(key: news, value: updates)
                      in updatesToPerform.entries)
                    {
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
  FutureOr<void> interpretStateless(Map<String, dynamic> nav) {
    assert(
      nav.mGetM('RapportSaisie')?.isNotEmpty ?? true,
      'Update request unsuccessful',
    );
  }

  @override
  List<VisualIdMixin> store(void result) => [];
}
