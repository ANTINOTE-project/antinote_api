import 'package:antinote/antinote.dart';

final class Tab {
  final int location;
  final List<Period>? periods;
  final Period? defaultPeriod;
  final List<Tab> subtabs;

  const Tab({
    required this.location,
    required this.periods,
    required this.defaultPeriod,
    required this.subtabs,
  });

  bool hasTab(int tab) {
    if (location == tab) return true;

    return subtabs.any((element) => element.hasTab(tab));
  }
}

extension AsTab on MapJsonNavigator {
  Tab asTab() {
    return Tab(
      location: get('G'),
      periods: mGetLM('listePeriodes')?.mapL((e) => e.asPeriod()),
      defaultPeriod: mGetM('periodeParDefaut')?.asPeriod(),
      subtabs: mGetLM('Onglet')?.mapL((e) => e.asTab()) ?? [],
    );
  }
}
