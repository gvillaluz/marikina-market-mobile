enum TicketStatus {
  active('Active'),
  paid('Paid'),
  voidType('Void'),
  disputed('Disputed');

  final String value;
  const TicketStatus(this.value);

  static TicketStatus fromValue(String value) {
    return TicketStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown status: $value'),
    );
  }
}