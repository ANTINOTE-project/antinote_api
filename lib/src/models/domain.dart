import 'package:antinote_api/src/helpers/json.dart';

extension AsListDomain on String {
  List<int> asDomain() {
    if (!startsWith('[') || !endsWith(']')) return [];

    if (length == 2) return [];

    final output = <int>[];
    for (final part in substring(1, length - 1).split(',')) {
      if (part.contains('..')) {
        final [start, end] = part.split('..').mapL(int.parse);
        for (int i = start; i <= end; i++) {
          output.add(i);
        }
      } else {
        output.add(int.parse(part));
      }
    }

    return output;
  }
}

extension AsStringDomain on Iterable<int> {
  String asDomain() {
    final sortedList = toList(growable: false)..sort((a, b) => a.compareTo(b));
    final List<List<int>> blocks = [];
    for (final value in sortedList) {
      final blockIndex = blocks.indexWhere(
        (element) => element.last == value - 1,
      );
      if (blockIndex == -1) {
        blocks.add([value]);
        continue;
      }

      blocks[blockIndex] = [...blocks[blockIndex], value];
    }

    final buffer = StringBuffer('[');
    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];

      if (block.length == 1) {
        buffer.write(block.single.toString());
      } else {
        buffer.write(block.first.toString());
        buffer.write('..');
        buffer.write(block.last.toString());
      }

      if (i != blocks.length - 1) {
        buffer.write(',');
      }
    }
    buffer.write(']');

    return buffer.toString();
  }
}
