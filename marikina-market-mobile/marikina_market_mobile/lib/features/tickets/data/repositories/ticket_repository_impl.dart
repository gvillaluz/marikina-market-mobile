import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/data/data_sources/ticket_remote_data_source.dart';
import 'package:marikina_market_mobile/core/shared/domain/entities/page_result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_detail.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_summary.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;
  TicketRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<TicketDetail>> getTicketDetail(int ticketId) async {
    try {
      final ticketModel = await remoteDataSource.getTicketDetailById(ticketId);
      return Result.success(ticketModel.toEntity());
    } on ValidationException catch (e) {
      return Result.failure(ValidationFailure(e.message));
    } on NotFoundException catch (e) {
      return Result.failure(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<Result<PageResult<TicketSummary>>> loadTickets(
    int offset,
    TicketStatus status,
  ) async {
    try {
      final ticketModels = await remoteDataSource.loadTickets(offset, status);

      return Result.success(ticketModels.toEntity((m) => m.toEntity()));
    } on ValidationException catch (e) {
      return Result.failure(ValidationFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }
}
