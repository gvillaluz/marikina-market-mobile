import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/skeleton_box.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/widgets/count_card.dart';

class WeeklyOverviewSection extends StatelessWidget {
  const WeeklyOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return Column(
            spacing: 20,
            children: [
              const SkeletonBox(height: 100),
              const SkeletonBox(height: 100),
              const SkeletonBox(height: 100),
            ],
          );
        }

        if (state is DashboardSummaryLoaded) {
          return Column(
            children: [
              CountCard(type: 'Ticket', count: state.dashboardSummary.ticketsRecorded),
              const SizedBox(height: 20,),
              CountCard(type: 'Warning', count: state.dashboardSummary.warningsRecorded),
              const SizedBox(height: 20,),
              CountCard(type: 'Total', count: state.dashboardSummary.totalRecorded),
            ],
          );
        }

        if (state is DashboardError) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70,),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withValues(alpha: .20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_off,
                    size: 32,
                    color: AppColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Unable to Load Tickets',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "We couldn't load the data right now.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.mediumGrey, height: 1.4),
                ),
                Text(
                  "This might be a temporary issue.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppColors.mediumGrey, height: 1.4),
                ),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}