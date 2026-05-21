import 'dart:convert';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/workspace/workspace.dart';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';

final class MobileInstanceParameters {
  final Uri baseUrl;

  final String establishmentName;
  final Map<String, dynamic> collectivity;
  final List<Workspace> workspaces;
  final bool editsAllowed; // This is probably ModeExclusif
  final Version version;
  final DateTime dateTime;

  final bool casActive;
  final Uri? casUrl;
  final String? casToken;

  const MobileInstanceParameters({
    required this.baseUrl,
    required this.establishmentName,
    required this.collectivity,
    required this.workspaces,
    required this.editsAllowed,
    required this.version,
    required this.dateTime,
    required this.casActive,
    required this.casUrl,
    required this.casToken,
  });

  static Future<MobileInstanceParameters?> fetch(Uri pronoteBaseUrl) async {
    try {
      final page = await http.get(
        pronoteBaseUrl.replace(
          pathSegments: [...pronoteBaseUrl.pathSegments, 'InfoMobileApp.json'],
          // That's a hard-coded constant in the PRONOTE mobile app
          queryParameters: {'id': '0D264427-EEFC-4810-A9E9-346942A862A4'},
        ),
        /*headers: {'x-requested-with': 'com.IndexEducation.Pronote'},*/
      );

      return (jsonDecode(page.body) as Map<String, dynamic>)
          .asMobileInstanceParameters(pronoteBaseUrl);
    } catch (e) {
      rethrow;
      // return null;
    }
  }
}
// InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4

extension AsMobileInstanceParameters on MapJsonNavigator {
  MobileInstanceParameters asMobileInstanceParameters(Uri baseUrl) {
    return MobileInstanceParameters(
      baseUrl: baseUrl,
      establishmentName: get('nomEtab'),
      collectivity: getM('collectivite'),
      workspaces: getLM('espaces').mapL((e) => e.asWorkspace()),
      editsAllowed: get('modeModif'),
      version: Version.parse(getL<int>('version').join('.')),
      dateTime: DateTime.parse(get('date')),
      casActive: mGo('CAS')?.get('actif') ?? false,
      casUrl: Uri.tryParse(mGo('CAS')?.get('casURL') ?? ''),
      casToken: mGo('CAS')?.get('jetonCAS'),
    );
  }
}
