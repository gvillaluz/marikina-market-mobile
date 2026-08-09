import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_ticket_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/repositories/inspection_repository.dart';

class LoadInspectionListUseCase {
  final InspectionRepository _repository;
  LoadInspectionListUseCase(this._repository);

  Future<Result<List<InspectionTicketSummary>>> call() async {
    return await _repository.loadInspections();
  }
}