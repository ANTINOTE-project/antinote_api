import 'dart:convert';

import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/version.dart';
import 'package:antinote_api/src/models/workspace/workspace.dart';
import 'package:http/http.dart' as http;

final class const MobileInstanceParameters({
  required final Uri baseUrl,

  required final String establishmentName,
  required final Map<String, dynamic> collectivity,
  required final List<Workspace> workspaces,
  // This is probably ModeExclusif
  required final bool editsAllowed,
  required final RemoteVersion version,
  required final DateTime dateTime,

  required final bool casActive,
  required final Uri? casUrl,
  required final String? casToken,
}) {
  factory decode(Map<String, dynamic> nav, Uri baseUrl) => .new(
    baseUrl: baseUrl,
    establishmentName: nav.get('nomEtab'),
    collectivity: nav.getM('collectivite'),
    workspaces: nav.getLM('espaces').mapL((e) => .decode(e)),
    editsAllowed: nav.get('modeModif'),
    version: RemoteVersion.fromVersionNumbers(
      versionNumbers: nav.getL<int>('version'),
    ),
    dateTime: DateTime.parse(nav.get('date')),
    casActive: nav.mGo('CAS')?.get('actif') ?? false,
    casUrl: Uri.tryParse(nav.mGo('CAS')?.get('casURL') ?? ''),
    casToken: nav.mGo('CAS')?.get('jetonCAS'),
  );

  static Future<MobileInstanceParameters?> fetch(Uri baseUrl) async {
    try {
      final page = await http.get(
        baseUrl.replace(
          pathSegments: [...baseUrl.pathSegments, 'InfoMobileApp.json'],
          // That's a hard-coded constant in the official mobile app
          queryParameters: {'id': '0D264427-EEFC-4810-A9E9-346942A862A4'},
        ),
        /*headers: {'x-requested-with': 'com.IndexEducation.<Redacted>'},*/
      );

      return .decode(jsonDecode(page.body) as Map<String, dynamic>, baseUrl);
    } catch (e) {
      rethrow;
      // return null;
    }
  }
}
// InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4
