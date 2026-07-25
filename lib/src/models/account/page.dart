import 'package:antinote/antinote.dart';

final class const AccountInformation({
  /// Length is 4.
  required final List<String> physicalAddress,
  required final String postalCode,
  required final String cityName,
  required final String regionName,
  required final String countryName,
  required final String emailAddress,
  required final String phoneNumber,
  required final String phoneNumberCode,
  required final String ineNumber,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    physicalAddress: [
      nav.get('adresse1'),
      nav.get('adresse2'),
      nav.get('adresse3'),
      nav.get('adresse4'),
    ],
    postalCode: nav.get('codePostal'),
    cityName: nav.get('ville'),
    regionName: nav.get('province'),
    countryName: nav.get('pays'),
    emailAddress: nav.get('eMail'),
    phoneNumber: nav.get('telephonePortable'),
    phoneNumberCode: nav.get('indicatifTel'),
    ineNumber: nav.get('numeroINE'),
  );
}

final class const ICalInformation({
  required final int type,
  required final String label,
  required final int place,
  required final String mainParameter,
  required final String extraParameter,
  required final bool agendaExport,
  required final bool scheduleExport,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    type: nav.get('G'),
    label: nav.get('L'),
    place: nav.get('P'),
    mainParameter: nav.get('paramICal'),
    extraParameter: nav.get('paramSuppl'),
    agendaExport: nav.get('exportAgenda'),
    scheduleExport: nav.get('exportEDT'),
  );

  Uri buildUri(RemoteSession session) => session.stack.baseUrl.replace(
    pathSegments: [
      ...session.stack.baseUrl.pathSegments,
      'ical',
      'myinformation.ics',
    ],
    queryParameters: {
      'icalsecurise': mainParameter,
      'version': session.stack.remoteVersion.toString(),
      'param': extraParameter,
    },
  );
}

final class const AccountICalInformation({
  required final bool withPersonalLink,
  required final bool withAgenda,
  required final bool withSchedule,
  required final List<ICalInformation> iCals,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    withPersonalLink: nav.get('avecLienPerso'),
    withAgenda: nav.get('avecAgenda'),
    withSchedule: nav.get('avecEDT'),
    iCals: nav.getLM('liste').mapL((e) => ICalInformation.decode(e)),
  );
}

final class const AccountSecurityInformation({
  required final Set<int> possibleModes,
  required final int mode,
  required final List<dynamic> connexionSources,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    possibleModes: nav.get('modesPossibles'),
    mode: nav.get('mode'),
    connexionSources: nav.getL('listeSourcesConnexions'),
  );

  bool canEdit(RemoteSession session) {
    // TODO: Mess around with the permission thingy.
    return session.instance.workspace.type.categories.contains(
      WorkspaceCategory.couldEditInformation,
    );
  }
}

final class const AccountPage({
  required final AccountInformation information,
  required final AccountICalInformation? iCalInformation,
  required final AccountSecurityInformation? securityInformation,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    information: AccountInformation.decode(nav.getM('Informations')),
    iCalInformation: nav
        .mGetM('iCal')
        .inn((value) => AccountICalInformation.decode(value)),
    securityInformation: nav
        .mGetM('securisation')
        .inn((value) => AccountSecurityInformation.decode(value)),
  );
}
