import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:marikina_market_mobile/features/dashboard/domain/use_cases/load_dashboard_summary_use_case.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final LoadDashboardSummaryUseCase loadDashboardSummaryUseCase;

  DashboardBloc({
    required this.loadDashboardSummaryUseCase
  }) : super(DashboardInitial()) {
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
  }

  Future<void> _onLoadDashboardSummary(LoadDashboardSummary event, Emitter emit) async {
    emit(DashboardLoading());

    final result = await loadDashboardSummaryUseCase();

    switch (result) {
      
      case Success<DashboardSummary>(: final data):
        emit(DashboardSummaryLoaded(dashboardSummary: data));
      case ResultFailure<DashboardSummary>(:var failure):
        emit(DashboardError(failure.message));
    }
  }
}