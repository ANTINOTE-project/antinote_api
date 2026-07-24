part of 'shared.dart';

final class BroadInstanceParameters({
  required super.shared,

  required final String navIdentifier,
  required final bool withPublicEstablishmentPage,
  required final List<Workspace> workspaces,
}) extends InstanceParameters {
  factory decode(Map<String, dynamic> nav, SharedInstanceParameters shared) =>
      .new(
        shared: shared,
        navIdentifier: nav.get('identifiantNav'),
        withPublicEstablishmentPage: nav.getB('avecPagePubliqueEtab'),
        workspaces: nav.getLM('espaces').mapL((e) => .decode(e)),
      );
}
