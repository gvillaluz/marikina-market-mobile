import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

class TicketSummary {
  final String controlNumber;
  final TicketStatus ticketStatus;
  final String businessName;
  final String stallNumber;
  final String marketSection;
  final DateTime createdAt;
  final DateTime overDueDate;
  final bool isOverDue;

  const TicketSummary({
    required this.controlNumber,
    required this.ticketStatus,
    required this.businessName,
    required this.stallNumber,
    required this.marketSection,
    required this.createdAt,
    required this.overDueDate,
    required this.isOverDue
  });
}