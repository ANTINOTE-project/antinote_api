import 'dart:typed_data';

import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/models/workspace/type.dart';
import 'package:antinote_api/src/protos/antinote_api/workspace.pb.dart';

final class const Workspace({
  required final WorkspaceType type,
  required final String label,
  required final String pathSegment,
  final bool hasCasLogin = false,

  // TODO: Add avecDelegation and protocole (check the meaning of those in the
  // TODO: demo instance)
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    type: WorkspaceType.values.byId(
      nav.eGet(['G', 'genreEspace']),
      defaultValue: WorkspaceType.eleve,
    ),
    label: nav.eGet(['L', 'nom']),
    pathSegment: nav.eGet(['url', 'URL']),
    hasCasLogin: nav.get('avecDelegation') ?? false,
  );

  static const Workspace common = Workspace(
    type: WorkspaceType.commun,
    label: '',
    pathSegment: '',
  );
  static const Workspace commonMobile = Workspace(
    type: WorkspaceType.mobileCommun,
    label: '',
    pathSegment: 'mobile.html',
  );

  Uri toSpecificAccountKind(Uri baseUri) {
    return baseUri.replace(
      pathSegments: [...baseUri.pathSegments, pathSegment],
    );
  }

  Map<String, dynamic> toJson() {
    return {'G': type.id, 'L': label, 'url': pathSegment};
  }

  factory Workspace.restore(SerializedWorkspace serialized) => Workspace(
    type: WorkspaceType.values.byId(serialized.typeIndex),
    label: serialized.label,
    pathSegment: serialized.pathSegment,
  );

  factory Workspace.restoreBinary(Uint8List data) =>
      Workspace.restore(SerializedWorkspace.fromBuffer(data));

  factory Workspace.restoreJson(String data) =>
      Workspace.restore(SerializedWorkspace.fromJson(data));

  SerializedWorkspace serialize() {
    return SerializedWorkspace(
      typeIndex: type.id,
      label: label,
      pathSegment: pathSegment,
    );
  }

  Map<String, dynamic> exportJson() => serialize().writeToJsonMap();

  String exportString() => serialize().writeToJson();

  Uint8List exportBinary() => serialize().writeToBuffer();
}
