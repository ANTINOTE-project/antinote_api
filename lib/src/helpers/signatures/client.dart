import 'package:antinote/src/models/user/resource.dart';
import 'package:antinote/src/protos/antinote/session.pb.dart';

extension MergeClientSignature on ClientSignature {
  ClientSignature changeTab(int newTab) {
    return rebuild((sig) {
      sig.tab = newTab;
    });
  }

  ClientSignature changeUserResource(UserResource resource) {
    return rebuild((sig) {
      sig.member = ClientSignature_Member(id: resource.id, type: resource.type);
    });
  }
}
