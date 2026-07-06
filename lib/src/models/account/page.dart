import 'package:antinote/antinote.dart';

final class AccountInformation {
  /// Length is 4.
  final List<String> physicalAddress;
  final String postalCode;
  final String cityName;
  final String regionName;
  final String countryName;
  final String emailAddress;
  final String phoneNumber;
  final String phoneNumberCode;
  final String ineNumber;

  const AccountInformation({
    required this.physicalAddress,
    required this.postalCode,
    required this.cityName,
    required this.regionName,
    required this.countryName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.phoneNumberCode,
    required this.ineNumber,
  });
}

extension AsAccountInformation on MapJsonNavigator {
  AccountInformation asAccountInformation() {
    return AccountInformation(
      physicalAddress: [
        get('adresse1'),
        get('adresse2'),
        get('adresse3'),
        get('adresse4'),
      ],
      postalCode: get('codePostal'),
      cityName: get('ville'),
      regionName: get('province'),
      countryName: get('pays'),
      emailAddress: get('eMail'),
      phoneNumber: get('telephonePortable'),
      phoneNumberCode: get('indicatifTel'),
      ineNumber: get('numeroINE'),
    );
  }
}

final class ICalInformation {
  final int type;
  final String label;
  final int place;
  final String mainParameter;
  final String extraParameter;
  final bool agendaExport;
  final bool scheduleExport;

  const ICalInformation({
    required this.type,
    required this.label,
    required this.place,
    required this.mainParameter,
    required this.extraParameter,
    required this.agendaExport,
    required this.scheduleExport,
  });

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

extension AsICalInformation on MapJsonNavigator {
  ICalInformation asICalInformation() {
    return ICalInformation(
      type: get('G'),
      label: get('L'),
      place: get('P'),
      mainParameter: get('paramICal'),
      extraParameter: get('paramSuppl'),
      agendaExport: get('exportAgenda'),
      scheduleExport: get('exportEDT'),
    );
  }
}

final class AccountICalInformation {
  final bool withPersonalLink;
  final bool withAgenda;
  final bool withSchedule;
  final List<ICalInformation> iCals;

  const AccountICalInformation({
    required this.withPersonalLink,
    required this.withAgenda,
    required this.withSchedule,
    required this.iCals,
  });
}

extension AsAccountICalInformation on MapJsonNavigator {
  AccountICalInformation asAccountICalInformation() {
    return AccountICalInformation(
      withPersonalLink: get('avecLienPerso'),
      withAgenda: get('avecAgenda'),
      withSchedule: get('avecEDT'),
      iCals: getLM('liste').mapL((e) => e.asICalInformation()),
    );
  }
}

final class AccountSecurityInformation {
  final Set<int> possibleModes;
  final int mode;
  final List<dynamic> connexionSources;

  const AccountSecurityInformation({
    required this.possibleModes,
    required this.mode,
    required this.connexionSources,
  });

  bool canEdit(RemoteSession session) {
    // TODO: Mess around with the permission thingy.
    return session.instance.workspace.type.categories.contains(
      WorkspaceCategory.couldEditInformation,
    );
  }
}

extension AsAccountSecurityInformation on MapJsonNavigator {
  AccountSecurityInformation asAccountSecurityInformation() {
    return AccountSecurityInformation(
      possibleModes: get('modesPossibles'),
      mode: get('mode'),
      connexionSources: getL('listeSourcesConnexions'),
    );
  }
}

final class AccountPage {
  final AccountInformation information;
  final AccountICalInformation? icalInformation;
  final AccountSecurityInformation? securityInformation;

  const AccountPage({
    required this.information,
    required this.icalInformation,
    required this.securityInformation,
  });
}

extension AsAccountPage on MapJsonNavigator {
  AccountPage asAccountPage() {
    return AccountPage(
      information: getM('Informations').asAccountInformation(),
      icalInformation: mGetM('iCal')?.asAccountICalInformation(),
      securityInformation: mGetM(
        'securisation',
      )?.asAccountSecurityInformation(),
    );
  }
}
