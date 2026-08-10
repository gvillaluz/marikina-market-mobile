import 'package:marikina_market_mobile/features/tickets/domain/entities/duplicate_ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_ticket_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/save_inspection_result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/vendor_summary.dart';

abstract class InspectionState {}

class InspectionInitial extends InspectionState {}

class InspectionLoading extends InspectionState {}

class InspectionTicketsLoaded extends InspectionState {
  final List<InspectionTicketSummary> ticketSummary;
  final bool hasMore;

  InspectionTicketsLoaded(this.ticketSummary, this.hasMore);
}

class InspectionError extends InspectionState {
  final String message;

  InspectionError(this.message);
}

class InspectionSubmitLoading extends InspectionState {}

class InspectionSubmitConnectionError extends InspectionState {
  final String message;
  InspectionSubmitConnectionError(this.message);
}

class InspectionSubmitError extends InspectionState {
  final String message;
  InspectionSubmitError(this.message);
}

class InspectionSaved extends InspectionState {}

class InspectionSearchLoading extends InspectionState {}
class InspectionSearchError extends InspectionState {
  final String error;
  InspectionSearchError(this.error);
}
class InspectionSearchList extends InspectionState {
  final List<VendorSummary> vendorList;
  InspectionSearchList(this.vendorList);
}

class InspectionVendorSelected extends InspectionState {
  final VendorSummary vendor;
  InspectionVendorSelected(this.vendor);
}

class OrdinanceSelectionLoading extends InspectionState {}

class OrdinanceSelectionError extends InspectionState {
  final String message;
  OrdinanceSelectionError(this.message);
}

class OrdinanceSelectionLoaded extends InspectionState {
  final List<Ordinance> ordinances;
  OrdinanceSelectionLoaded(this.ordinances);
}

class FineSummaryLoading extends InspectionState {}

class FineSummaryError extends InspectionState {
  final String message;
  FineSummaryError(this.message);
}

class FineSummaryNetworkError extends InspectionState {
  final String message;
  FineSummaryNetworkError(this.message);
}

class FineSummaryLoaded extends InspectionState {
  final FineSummary summary;
  FineSummaryLoaded(this.summary);
}

class SubmitNewTicketLoading extends InspectionState {}

class SubmitNewTicketError extends InspectionState {
  final String message;
  SubmitNewTicketError(this.message);
}

class SubmitNewTicketSuccess extends InspectionState {
  final SaveInspectionResult result;
  SubmitNewTicketSuccess(this.result);
}

class DuplicationConflictInspection extends InspectionState {
  final String message;
  final List<DuplicateOrdinance> duplicateOrdinances;
  DuplicationConflictInspection(this.message, this.duplicateOrdinances);
}