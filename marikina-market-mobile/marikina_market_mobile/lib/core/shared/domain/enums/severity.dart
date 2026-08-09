enum Severity implements Comparable<Severity> {
  low("Low"),
  medium("Medium"),
  high("High");

  final String value;
  const Severity(this.value);

  static Severity fromValue(String value) {
    return Severity.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown severity: $value'),
    );
  }

  @override
  int compareTo(Severity other) => index.compareTo(other.index);
}