part of 'shared.dart';

final class BroadInstanceParameters extends InstanceParameters {
  final String navIdentifier;
  final bool withPublicEstablishmentPage;
  final List<Workspace> workspaces;

  BroadInstanceParameters({
    required super.shared,
    required this.navIdentifier,
    required this.withPublicEstablishmentPage,
    required this.workspaces,
  }) : super.shared();
}

extension AsBroadInstanceParameters on MapJsonNavigator {
  BroadInstanceParameters asBroadInstanceParameters(
    SharedInstanceParameters shared,
  ) {
    return BroadInstanceParameters(
      shared: shared,
      navIdentifier: get('identifiantNav'),
      withPublicEstablishmentPage: get('avecPagePubliqueEtab'),
      workspaces: getLM('espaces').mapL((e) => e.asWorkspace()),
    );
  }
}
