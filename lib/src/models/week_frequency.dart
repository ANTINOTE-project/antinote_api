final class const WeekFrequency({
  required final String label,
  required final int fortnight,
}) {
  @override
  int get hashCode => Object.hash(label, fortnight);

  @override
  bool operator ==(Object other) {
    return other is WeekFrequency &&
        label == other.label &&
        fortnight == other.fortnight;
  }
}
