import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/discussion/label.dart';
import 'package:antinote/src/models/discussion/node.dart';

final class DiscussionPage {
  final List<DiscussionLabel> labels;
  final List<DiscussionRootNode> discussions;

  const DiscussionPage({required this.labels, required this.discussions});
}

extension AsDiscussionPage on MapJsonNavigator {
  DiscussionPage asDiscussionPage() {
    return DiscussionPage(
      labels: mGetLM('listeEtiquettes')?.mapL((e) => e.asDiscussionLabel()) ??
          [],
      discussions: getLM('listeMessagerie').asDiscussionRootsList(),
    );
  }
}
