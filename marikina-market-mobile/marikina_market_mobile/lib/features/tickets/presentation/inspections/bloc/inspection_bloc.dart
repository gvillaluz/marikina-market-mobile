import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/params/save_inspection_params.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_ticket_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/page_result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/save_inspection_result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/get_fine_summary_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_inspection_list_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_ordinances_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/save_inspection_ticket_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/search_vendor_by_code_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/search_vendor_by_stall_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';

class InspectionBloc extends Bloc<InspectionEvent, InspectionState> {
  final LoadInspectionListUseCase loadInspectionListUseCase;
  final LoadOrdinancesUseCase loadOrdinancesUseCase;
  final SearchVendorByCodeUseCase searchVendorByCodeUseCase;
  final SearchVendorByStallUseCase searchVendorByStallUseCase;
  final GetFineSummaryUseCase getFineSummaryUseCase;
  final SaveInspectionTicketUseCase saveInspectionTicketUseCase;

  List<InspectionTicketSummary> _inspectionSummary = [];
  List<InspectionTicketSummary> get inspectionSummaries => _inspectionSummary; 

  List<Ordinance> _ordinances = [];
  List<Ordinance> get ordinances => _ordinances;
  bool _hasLoadedTickets = false;

  InspectionBloc({
    required this.loadInspectionListUseCase,
    required this.loadOrdinancesUseCase,
    required this.searchVendorByCodeUseCase,
    required this.searchVendorByStallUseCase,
    required this.getFineSummaryUseCase,
    required this.saveInspectionTicketUseCase
  }) : super(InspectionInitial()) {
    on<LoadOrdinances>(_onLoadOrdinances);
    on<LoadInspectionTickets>(_onLoadInspectionTickets);
    on<SearchByCodeRequested>(_onSearchByCodeRequested);
    on<SearchByStallNumberRequested>(_onSearchByStallNumberRequested);
    on<LoadOrdinanceSelection>(_onLoadOrdinanceSelection);
    on<FineSummaryRequested>(_onFineSummaryRequested);
    on<NewInspectionSubmitted>(_onNewInspectionSubmitted);
  }

  Future<void> _onLoadOrdinances(LoadOrdinances event, Emitter emit) async {
    final result = await loadOrdinancesUseCase();

    if (result is Success<List<Ordinance>>) {
      _ordinances = result.data;
    }
  }

  Future<void> _onLoadInspectionTickets(LoadInspectionTickets event, Emitter<InspectionState> emit) async {
    emit(InspectionLoading());

    final result = await loadInspectionListUseCase(event.offset, event.type);

    switch (result) {
      case Success<PageResult<InspectionTicketSummary>>():
        _inspectionSummary = event.offset == 0
          ? result.data.tickets
          : [..._inspectionSummary, ...result.data.tickets];
        _hasLoadedTickets = true;
        emit(InspectionTicketsLoaded(_inspectionSummary, result.data.hasMore));
        
      case ResultFailure<PageResult<InspectionTicketSummary>>():
        emit(InspectionTicketsLoaded([], false));
    }
  }

  Future<void> _onSearchByCodeRequested(SearchByCodeRequested event, Emitter emit) async {
    emit(InspectionSearchLoading());

    final result = await searchVendorByCodeUseCase(event.codeValue);

    switch (result) {
      case Success(: final data):
        emit(InspectionVendorSelected(data));

      case ResultFailure(failure: final failure):
        emit(InspectionSearchError(failure.message));
    }
  }

  Future<void> _onSearchByStallNumberRequested(SearchByStallNumberRequested event, Emitter emit) async {
    emit(InspectionSearchLoading());

    final result = await searchVendorByStallUseCase(event.stallNumber);

    switch (result) {
      case Success(: final data):
        emit(InspectionSearchList(data));

      case ResultFailure(failure: final failure):
        emit(InspectionSearchError(failure.message));
    }
  }

  Future<void> _onLoadOrdinanceSelection(LoadOrdinanceSelection event, Emitter emit) async {
    emit(OrdinanceSelectionLoading());

    if (_ordinances.isNotEmpty) {
      emit(OrdinanceSelectionLoaded(ordinances));
      return;
    } 

    final result = await loadOrdinancesUseCase();

    if (result is Success<List<Ordinance>>) {
      _ordinances = result.data;
      emit(OrdinanceSelectionLoaded(_ordinances));
    } else if (result is ResultFailure<List<Ordinance>>) {
      emit(OrdinanceSelectionError(result.failure.message));
    }
  }

  Future<void> _onFineSummaryRequested(FineSummaryRequested event, Emitter emit) async {
    if (event.vendorId == null) {
      emit(FineSummaryError('Vendor is required to calculate fines.'));
      return;
    }

    emit(FineSummaryLoading());

    final result = await getFineSummaryUseCase(
      event.ordinanceIds,
      event.vendorId
    );

    switch (result) {
      case Success<FineSummary>(data: final data):
        emit(FineSummaryLoaded(data));

      case ResultFailure(failure: NetworkFailure(: final message) ||
                                  ServerFailure(: final message) ||
                                  UnauthorizedFailure(: final message) ||
                                  CacheFailure(: final message) ||
                                  TokenValidationFailure(: final message) || 
                                  ConflictFailure(: final message)):
        emit(FineSummaryNetworkError(message));

      case ResultFailure(failure: ValidationFailure(: final message)):
        emit(FineSummaryError(message));
    }
  }

  Future<void> _onNewInspectionSubmitted(NewInspectionSubmitted event, Emitter emit) async {
    emit(SubmitNewTicketLoading());

    final result = await saveInspectionTicketUseCase(SaveInspectionParams(
      vendorId: event.vendorId, 
      marketSectionId: event.marketSectionId, 
      enforcerId: event.enforcerId,
      ticketType: event.ticketType, 
      description: event.description, 
      penaltyType: event.penaltyType, 
      communityServiceHours: event.communityServiceHours,
      ordinanceIds: event.ordinanceIds, 
      evidences: event.evidences
    ));

    switch (result) {
      case Success<SaveInspectionResult>(: final data):
        emit(SubmitNewTicketSuccess(data));
        if (_hasLoadedTickets) {
          _inspectionSummary = [..._inspectionSummary, data.inspectionSummary];
        } else {
          add(LoadInspectionTickets(0, ViolationType.warning));
        }
      
      case ResultFailure(failure: NetworkFailure(: final message) ||
                                  ServerFailure(: final message) ||
                                  CacheFailure(: final message) ||
                                  TokenValidationFailure(: final message)):
        emit(InspectionSubmitConnectionError(message));

      case ResultFailure(failure: UnauthorizedFailure(: final message) ||
                                  ValidationFailure(: final message)):
        emit(InspectionSubmitError(message));
      case ResultFailure(failure: ConflictFailure(: final message, : final droppedOrdinances)):
        emit(DuplicationConflictInspection(message, droppedOrdinances));
    }
  }
}