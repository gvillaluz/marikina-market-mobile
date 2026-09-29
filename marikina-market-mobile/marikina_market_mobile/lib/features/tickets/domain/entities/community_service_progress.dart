class CommunityServiceProgress {
  final int ticketId;
  final int hoursRequired;
  final double hoursCompleted;
  final double hoursRemaining;
  final double completionPercentage;
  final List<CommunityServiceLog> entries;

  const CommunityServiceProgress({
    required this.ticketId,
    required this.hoursRequired,
    required this.hoursCompleted,
    required this.hoursRemaining,
    required this.completionPercentage,
    required this.entries,
  });
}

class CommunityServiceLog {
  final DateTime serviceDate;
  final double hoursWorked;
  final String proofUrl;

  const CommunityServiceLog({
    required this.serviceDate,
    required this.hoursWorked,
    required this.proofUrl,
  });
}
