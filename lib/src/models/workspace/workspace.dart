import 'dart:typed_data';

import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/workspace/type.dart';
import 'package:antinote/src/protos/antinote/workspace.pb.dart';

final class Workspace {
  final WorkspaceType type;
  final String label;
  final String pathSegment;
  final bool hasCasLogin;

  // TODO: Add avecDelegation and protocole (check the meaning of those in the
  // TODO: demo instance)

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

  const Workspace({
    required this.type,
    required this.label,
    required this.pathSegment,
    this.hasCasLogin = false,
  });

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

extension AsWorkspace on MapJsonNavigator {
  Workspace asWorkspace() {
    return Workspace(
      type: WorkspaceType.values.byId(
        eGet(['G', 'genreEspace']),
        defaultValue: WorkspaceType.eleve,
      ),
      label: eGet(['L', 'nom']),
      pathSegment: eGet(['url', 'URL']),
      hasCasLogin: get('avecDelegation') ?? false,
    );
  }
}
