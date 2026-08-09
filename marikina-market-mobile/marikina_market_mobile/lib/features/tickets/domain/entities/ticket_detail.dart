import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/violation_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ordinance_category.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class TicketDetail {
  final int ticketId;
  final String? controlNumber;
  final int enforcerId;
  final int vendorId;
  final ViolationType violationType;
  final String stallNumber;
  final String tradeName;
  final String lastName;
  final String firstName;
  final String? address;
  final List<ViolationSummary> violations;
  final DateTime issuedAt;
  final String marketSectionName;
  final List<OrdinanceCategory> categories;
  final String description;
  final Severity? severity;
  final PenaltyType? penaltyType;
  final DateTime? dueDate;
  final double? totalFineAmount;
  final List<String>? evidenceUrls;

  const TicketDetail({
    required this.ticketId,
    this.controlNumber,
    required this.enforcerId,
    required this.vendorId,
    required this.violationType,
    required this.stallNumber,
    required this.tradeName,
    required this.lastName,
    required this.firstName,
    required this.address,
    required this.violations,
    required this.issuedAt,
    required this.marketSectionName,
    required this.categories,
    required this.description,
    this.severity,
    this.penaltyType,
    this.dueDate,
    this.totalFineAmount,
    this.evidenceUrls
  });
}