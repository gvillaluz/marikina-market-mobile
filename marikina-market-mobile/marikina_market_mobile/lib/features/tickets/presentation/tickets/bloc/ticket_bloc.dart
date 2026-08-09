import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_detail.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_ticket_detail_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final LoadTicketDetailUseCase loadTicketDetailUseCase;

  TicketBloc({
    required this.loadTicketDetailUseCase
  }) : super(TicketInitial()) {
    on<LoadTicketSummary>(_onLoadTicketSummary); 
    on<LoadTicketDetail>(_onLoadTicketDetail);
  }

  Future<void> _onLoadTicketSummary(LoadTicketSummary event, Emitter<TicketState> emit) async {
    emit(TicketLoading());

    await Future.delayed(const Duration(seconds: 3));

    emit(TicketsLoaded([]));
  }

  Future<void> _onLoadTicketDetail(LoadTicketDetail event, Emitter emit) async {
    emit(TicketDetailLoading());

    final result = await loadTicketDetailUseCase(event.ticketId);

    switch (result) {
      case ResultFailure<TicketDetail>(: final failure):
        emit(TicketError(failure.message));

      case Success<TicketDetail>(: final data):
        emit(TicketDetailLoaded(data));
    }
  }
}