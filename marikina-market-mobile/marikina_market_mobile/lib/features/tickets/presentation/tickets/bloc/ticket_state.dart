import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_detail.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_summary.dart';

abstract class TicketState {}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketsLoaded extends TicketState {
  final List<TicketSummary> ticketSummary;
  final bool hasMore;
  TicketsLoaded(this.ticketSummary, this.hasMore);
}

class TicketError extends TicketState {
  final String message;
  TicketError(this.message);
}

class TicketDetailLoading extends TicketState {}

class TicketDetailLoaded extends TicketState {
  final TicketDetail ticket;
  TicketDetailLoaded(this.ticket);
}