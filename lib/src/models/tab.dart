import 'package:antinote_api/antinote_api.dart';

final class const Tab({
  required final int location,
  required final List<Period>? periods,
  required final Period? defaultPeriod,
  required final List<Tab> subtabs,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    location: nav.get('G'),
    periods: nav.mGetLM('listePeriodes')?.mapL((e) => .decode(e)),
    defaultPeriod: nav.mGetM('periodeParDefaut').inn((value) => .decode(value)),
    subtabs: nav.mGetLM('Onglet')?.mapL((e) => .decode(e)) ?? [],
  );

  bool hasTab(int tab) {
    if (location == tab) return true;

    return subtabs.any((element) => element.hasTab(tab));
  }
}
