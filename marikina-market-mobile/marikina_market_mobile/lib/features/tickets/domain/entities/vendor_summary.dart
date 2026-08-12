class VendorSummary {
  final int id;
  final String username;
  final String stallNumber;
  final String tradeName;
  final String lastName;
  final String firstName;
  final String middleName;
  final String address;
  final int marketSectionId;
  final String marketSectionName;
  final bool canIssueWarning;
  final DateTime? activeWarningIssuedAt;

  VendorSummary({required this.id, required this.username, required this.stallNumber, required this.tradeName, required this.lastName, required this.firstName, required this.middleName, required this.address, required this.marketSectionId, required this.marketSectionName, required this.canIssueWarning, this.activeWarningIssuedAt});
}