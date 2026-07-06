import 'dart:async';

import 'package:antinote/antinote.dart';

class HomePageAccessor extends StatefulAccessor<HomePage, RemoteSession> {
  final int weekNumber;
  final DateTime nextWorkingDay;
  final List<HomePageWidgetType>? widgets;
  final Map<String, dynamic> extras;

  const HomePageAccessor({
    required this.weekNumber,
    required this.nextWorkingDay,
    this.widgets,
    this.extras = const {},
  });

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    final weekNumberObject = {'numeroSemaine': weekNumber};
    final businessDayObject = {'_T': 7, 'V': nextWorkingDay.asRemoteDate()};
    return stack
        .post(
          Call.function(
            name: 'PageAccueil',
            dataSec: {
              stack.vocab.data: {
                'avecConseilDeClasse': true,
                'coursNonAssures': weekNumberObject,
                'dateGrille': businessDayObject,
                'donneesProfs': weekNumberObject,
                'donneesVS': weekNumberObject,
                'EDT': weekNumberObject,
                'exclusions': weekNumberObject,
                'incidents': weekNumberObject,
                'menuDeLaCantine': {'date': businessDayObject},
                'modificationsEDT': {
                  'date': businessDayObject,
                  ...weekNumberObject,
                },
                'partenaireCDI': {'CDI': {}},
                'personnelsAbsents': weekNumberObject,
                'previsionnelAbsServiceAnnexe': {'date': businessDayObject},
                'registreAppel': {'date': businessDayObject},
                'tableauDeBord': {'date': businessDayObject},
                'TAFARendre': {'date': businessDayObject},
                'TAFEtActivites': {'date': businessDayObject},

                if (widgets != null) 'widgets': widgets!.mapL((e) => e.id),

                ...extras,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<RemoteSession> collectState(RemoteSession session) => session;

  @override
  FutureOr<HomePage> interpret(MapJsonNavigator nav, RemoteSession state) =>
      HomePage.decode(nav, state);

  @override
  List<VisualIdMixin> store(HomePage result) => result.widgets
      .mapL((e) => e.toStore)
      .fold(
        <VisualIdMixin>[],
        (previousValue, element) => previousValue + element,
      );
}
