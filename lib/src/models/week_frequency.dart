final class WeekFrequency {
  final String label;
  final int fortnight;

  const WeekFrequency({required this.label, required this.fortnight});

  @override
  int get hashCode => Object.hash(label, fortnight);

  @override
  bool operator ==(Object other) {
    return other is WeekFrequency &&
        label == other.label &&
        fortnight == other.fortnight;
  }
}
