import 'dart:math';
import 'dart:typed_data';

import 'package:antinote/antinote.dart';

final class const DiscussionPage({
  required final List<DiscussionLabel> labels,
  required final List<DiscussionRootNode> discussions,
}) with VisualIdMixin {
  static List<DiscussionRootNode> _buildDiscussionTree(
    List<Map<String, dynamic>> nav,
  ) {
    if (nav.empty) return [];

    final biggestDepth = nav.fold(
      0,
      (previousValue, element) => max(previousValue, element.get('profondeur')),
    );

    Map<int, List<DiscussionNode>> depthMaps = {};
    List<DiscussionRootNode> finalList = <DiscussionRootNode>[];

    for (int depth = biggestDepth; depth >= 0; depth--) {
      for (int nodeIndex = 0; nodeIndex < nav.length; nodeIndex++) {
        final rawNode = nav.get(nodeIndex);
        if (rawNode.get('profondeur') != depth) continue;

        final node = DiscussionNode.decode(
          nodeIndex,
          rawNode,
          depthMaps.remove(nodeIndex) ?? [],
        );

        if (rawNode.has('indicePere')) {
          final parent = rawNode.get<int>('indicePere');
          if (depthMaps.containsKey(parent)) {
            depthMaps[parent]!.add(node);
          } else {
            depthMaps[parent] = [node];
          }
        } else {
          assert(
            node is DiscussionRootNode,
            'Only root nodes do not have parent indices.',
          );
          finalList.add(node as DiscussionRootNode);
        }
      }
    }

    return finalList;
  }

  factory decode(Map<String, dynamic> nav) => .new(
    labels: nav.mGetLM('listeEtiquettes')?.mapL((e) => .decode(e)) ?? [],
    discussions:
        nav
            .mGetLM('listeMessagerie')
            .inn((value) => _buildDiscussionTree(value)) ??
        [],
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* discussions.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final rootDiscussion in discussions)
      for (final node in rootDiscussion.flatten())
        .new(
          exchanger: (nav) => nav.getLM('listeMessagerie').get(node.index),
          value: node,
        ),
  ];
}
