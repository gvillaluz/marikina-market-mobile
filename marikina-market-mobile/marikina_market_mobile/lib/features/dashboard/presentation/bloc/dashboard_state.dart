import 'package:marikina_market_mobile/features/dashboard/domain/entities/dashboard_summary.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSummaryLoaded extends DashboardState {
  final DashboardSummary dashboardSummary;

  DashboardSummaryLoaded({
    required this.dashboardSummary
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}