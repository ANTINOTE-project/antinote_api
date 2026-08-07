import 'dart:convert';
import 'dart:math';

import 'package:antinote_api/antinote_api.dart';
import 'package:http/http.dart' as http;

final class GeolocatedInstance {
  final Uri baseUrl;
  final String name;
  final double latitude;
  final double longitude;
  final String postalCode;

  final double distance;

  const GeolocatedInstance({
    required this.baseUrl,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    required this.distance,
  });
}

const _earthDiameter = 6371.2 * 2;

extension AsGeolocatedInstance on Map<String, dynamic> {
  double _toRadians(double degrees) => degrees * pi / 180;

  double _hav(double angle) {
    final s = sin(angle / 2);
    return s * s;
  }

  double _calculateDistance(
    double lat0,
    double lon0,
    double lat1,
    double lon1,
  ) {
    final dp = _toRadians(lat0 - lat1);
    final dl = _toRadians(lon0 - lon1);

    final rLat0 = _toRadians(lat0);
    final rLat1 = _toRadians(lat1);

    return asin(sqrt(_hav(dp) + cos(rLat0) * cos(rLat1) * _hav(dl))) *
        _earthDiameter;
  }

  GeolocatedInstance asGeolocatedInstance(double lat0, double lon0) {
    final lat1 = double.parse(get('lat'));
    final lon1 = double.parse(get('long'));

    return GeolocatedInstance(
      baseUrl: Uri.parse(get('url')),
      name: get('nomEtab'),
      latitude: lat1,
      longitude: lon1,
      postalCode: get('cp'),
      distance: _calculateDistance(lat0, lon0, lat1, lon1),
    );
  }
}

Future<List<GeolocatedInstance>> findNearbyInstances(
  double lat,
  double lon, {
  String geolocationUrl = 'https://www.index-education.com/swie/geoloc.php',
}) async {
  final req = http.Request('POST', Uri.parse(geolocationUrl));
  req.headers['Content-Type'] =
      'application/x-www-form-urlencoded;charset=UTF-8';
  // req.body =
  //     'data=${}';
  req.bodyFields = {
    'data': jsonEncode({
      'lat': lat.toString(),
      'long': lon.toString(),
      'nomFonction': 'geoLoc',
    }),
  };
  final res = await req.send();
  final resBody = await res.stream.bytesToString();
  try {
    final parsed = jsonDecode(resBody) as List<dynamic>;

    return parsed.mapL(
      (e) => (e as Map<String, dynamic>).asGeolocatedInstance(lat, lon),
    )..sort((a, b) => a.distance.compareTo(b.distance));
  } catch (e, st) {
    libLog.severe('Could not read geolocated instances.', e, st);
    libLog.severe('Response is: $resBody');
    libLog.severe('Request was: ${req.body}');

    return [];
  }
}
