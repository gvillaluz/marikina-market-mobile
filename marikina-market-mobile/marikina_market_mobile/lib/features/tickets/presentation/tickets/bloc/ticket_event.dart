abstract class TicketEvent {}

class LoadTicketSummary extends TicketEvent {}

class LoadTicketDetail extends TicketEvent {
  final int ticketId;
  LoadTicketDetail(this.ticketId);
}