import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/challenge.dart';

final class IdentificationAccessor extends StatelessAccessor<Challenge> {
  final String username;
  final String deviceUuid;

  final Map<String, dynamic> extra;

  const IdentificationAccessor.password({
    required this.username,
    required this.deviceUuid,
  }) : extra = const {
         'enConnexionAppliMobile': false,
         'demandeConnexionAppliMobile': true,
         'demandeConnexionAppliMobileJeton': false,
         'pourENT': false,
       };

  const IdentificationAccessor.token({
    required this.username,
    required this.deviceUuid,
  }) : extra = const {
         'enConnexionAppliMobile': true,
         'demandeConnexionAppliMobile': false,
         'demandeConnexionAppliMobileJeton': false,
         'pourENT': false,
       };

  const IdentificationAccessor.qrCode({
    required this.username,
    required this.deviceUuid,
  }) : extra = const {
         'enConnexionAppliMobile': false,
         'demandeConnexionAppliMobile': true,
         'demandeConnexionAppliMobileJeton': true,
         'pourENT': false,
       };

  const IdentificationAccessor.cas({
    required String tokenId,
    required this.deviceUuid,
  }) : username = tokenId,
       extra = const {
         'enConnexionAppliMobile': false,
         'demandeConnexionAppliMobile': true,
         'demandeConnexionAppliMobileJeton': false,
         'pourENT': true,
       };

  const IdentificationAccessor({
    required this.username,
    required this.extra,
    required this.deviceUuid,
  });

  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'Identification',
            dataSec: {
              session.stack.vocab.data: {
                // EGenreConnexion (whether the teacher used the "In class"/"At home" picker)
                'genreConnexion': 0,
                'genreEspace': session.stack.temporaryWorkspace.type.id,
                'identifiant': username,
                'uuidAppliMobile': deviceUuid,
                'loginTokenSAV': '',
                'informationsAppareil': null,
                'enConnexionAuto': false,
                'demandeConnexionAuto': false,
                ...extra,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  Challenge interpretStateless(Map<String, dynamic> nav) => .decode(nav);

  @override
  List<VisualIdMixin> store(Challenge result) => [result];
}
