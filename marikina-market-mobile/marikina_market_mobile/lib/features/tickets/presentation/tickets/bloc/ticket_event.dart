import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

abstract class TicketEvent {}

class LoadTicketSummary extends TicketEvent {
  final int offset;
  final TicketStatus status;
  
  LoadTicketSummary({
    required this.offset, 
    required this.status
  });
}

class LoadTicketDetail extends TicketEvent {
  final int ticketId;
  LoadTicketDetail(this.ticketId);
}