import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';

abstract class TicketEvent {}

class LoadTicketSummary extends TicketEvent {
  final String search;
  final int offset;
  final TicketStatus status;

  LoadTicketSummary({
    this.search = '',
    this.offset = 0,
    this.status = TicketStatus.pending,
  });
}

class LoadTicketDetail extends TicketEvent {
  final int ticketId;
  LoadTicketDetail(this.ticketId);
}
