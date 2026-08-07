import 'package:antinote_api/src/models/user/resource.dart';
import 'package:antinote_api/src/protos/antinote/session.pb.dart';

extension MergeClientSignature on ClientSignature {
  ClientSignature changeTab(int newTab) {
    if (!isFrozen) freeze();

    return rebuild((sig) {
      sig.tab = newTab;
    })..freeze();
  }

  ClientSignature changeUserResource(UserResource resource) {
    if (!isFrozen) freeze();

    return rebuild((sig) {
      sig.member = ClientSignature_Member(id: resource.id, type: resource.type);
    })..freeze();
  }

  Map<String, dynamic> toJson() => {
    'onglet': tab,
    if (hasMember()) 'membre': {'N': member.id, 'G': member.type},
  };
}
