import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

class TicketSummary {
  final int ticketId;
  final int enforcerId;
  final int vendorId;
  final String controlNumber;
  final TicketStatus ticketStatus;
  final String businessName;
  final String stallNumber;
  final String marketSection;
  final DateTime issuedAt;
  final DateTime updatedAt;
  final DateTime overDueDate;
  final bool isOverDue;

  const TicketSummary({
    required this.ticketId,
    required this.enforcerId,
    required this.vendorId,
    required this.controlNumber,
    required this.ticketStatus,
    required this.businessName,
    required this.stallNumber,
    required this.marketSection,
    required this.issuedAt,
    required this.updatedAt,
    required this.overDueDate,
    required this.isOverDue
  });
}