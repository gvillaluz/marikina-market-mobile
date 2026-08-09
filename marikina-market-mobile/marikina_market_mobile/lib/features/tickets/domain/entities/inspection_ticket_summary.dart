import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class InspectionTicketSummary {
  final int ticketId;
  final ViolationType ticketType;
  final String? controlNumber;
  final int vendorId;
  final String vendorFirstName;
  final String vendorLastName;
  final String businessName;
  final int marketSectionId;
  final String marketSection;
  final int enforcerId;
  final String stallNumber;
  final TicketStatus status;
  final Severity? severity;
  final List<String> ordinance;
  final DateTime issuedAt;
  final DateTime? overDueDate;
  final bool? isOverDue;
  final DateTime updatedAt;

  InspectionTicketSummary({
    required this.ticketId, 
    required this.ticketType, 
    required this.controlNumber, 
    required this.vendorId, 
    required this.vendorFirstName, 
    required this.vendorLastName, 
    required this.businessName, 
    required this.marketSectionId, 
    required this.marketSection, 
    required this.enforcerId, 
    required this.stallNumber, 
    required this.status, 
    required this.severity, 
    required this.ordinance, 
    required this.issuedAt, 
    required this.overDueDate, 
    required this.isOverDue,
    required this.updatedAt
  });
}