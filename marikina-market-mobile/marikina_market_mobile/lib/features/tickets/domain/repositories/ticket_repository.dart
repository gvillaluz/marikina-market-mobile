import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_detail.dart';

abstract class TicketRepository {
  Future<Result<TicketDetail>> getTicketDetail(int ticketId);
}