import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/page_result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_detail.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

abstract class TicketRepository {
  Future<Result<PageResult<TicketSummary>>> loadTickets(int offset, TicketStatus status);
  Future<Result<TicketDetail>> getTicketDetail(int ticketId);
}