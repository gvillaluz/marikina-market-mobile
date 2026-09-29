import 'package:marikina_market_mobile/features/tickets/domain/entities/community_service_progress.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_receipt_proof.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';

class TicketReceiptProofModel {
  final int ticketId;
  final PenaltyType penaltyType;
  final List<String> proofUrls;

  const TicketReceiptProofModel({
    required this.ticketId,
    required this.penaltyType,
    required this.proofUrls,
  });

  factory TicketReceiptProofModel.fromJson(Map<String, dynamic> json) {
    return TicketReceiptProofModel(
      ticketId: json['ticketId'] as int,
      penaltyType: PenaltyType.fromValue(json['penaltyType'] as String),
      proofUrls: List<String>.from(json['proofUrls'] as List<dynamic>),
    );
  }

  TicketReceiptProof toEntity() => TicketReceiptProof(
    ticketId: ticketId,
    penaltyType: penaltyType,
    proofUrls: proofUrls,
  );
}

class CommunityServiceProgressModel {
  final int ticketId;
  final int hoursRequired;
  final double hoursCompleted;
  final double hoursRemaining;
  final double completionPercentage;
  final List<CommunityServiceLogModel> entries;

  const CommunityServiceProgressModel({
    required this.ticketId,
    required this.hoursRequired,
    required this.hoursCompleted,
    required this.hoursRemaining,
    required this.completionPercentage,
    required this.entries,
  });

  factory CommunityServiceProgressModel.fromJson(Map<String, dynamic> json) {
    return CommunityServiceProgressModel(
      ticketId: json['ticketId'] as int,
      hoursRequired: (json['hoursRequired'] as num).toInt(),
      hoursCompleted: (json['hoursCompleted'] as num).toDouble(),
      hoursRemaining: (json['hoursRemaining'] as num).toDouble(),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      entries: (json['entries'] as List<dynamic>)
          .map(
            (entry) => CommunityServiceLogModel.fromJson(
              entry as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  CommunityServiceProgress toEntity() => CommunityServiceProgress(
    ticketId: ticketId,
    hoursRequired: hoursRequired,
    hoursCompleted: hoursCompleted,
    hoursRemaining: hoursRemaining,
    completionPercentage: completionPercentage,
    entries: entries.map((entry) => entry.toEntity()).toList(),
  );
}

class CommunityServiceLogModel {
  final DateTime serviceDate;
  final double hoursWorked;
  final String proofUrl;

  const CommunityServiceLogModel({
    required this.serviceDate,
    required this.hoursWorked,
    required this.proofUrl,
  });

  factory CommunityServiceLogModel.fromJson(Map<String, dynamic> json) {
    return CommunityServiceLogModel(
      serviceDate: DateTime.parse(json['serviceDate'] as String),
      hoursWorked: (json['hoursWorked'] as num).toDouble(),
      proofUrl: json['proofUrl'] as String,
    );
  }

  CommunityServiceLog toEntity() => CommunityServiceLog(
    serviceDate: serviceDate,
    hoursWorked: hoursWorked,
    proofUrl: proofUrl,
  );
}
