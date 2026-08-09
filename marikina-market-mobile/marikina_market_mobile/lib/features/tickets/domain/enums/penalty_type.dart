enum PenaltyType {
  cashFine("CashFine"),
  bloodDonation("BloodDonation"),
  communityService("CommunityService");

  final String value;
  const PenaltyType(this.value);

  static PenaltyType fromValue(String value) {
    return PenaltyType.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Unknown penalty: $value'),
    );
  }
}