import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/widgets/user_banner.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/widgets/view_inspections_btn.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/widgets/weekly_overview_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(LoadDashboardSummary());

          await context.read<DashboardBloc>().stream.firstWhere(
            (state) =>
                state is DashboardSummaryLoaded || state is DashboardError,
          );
        },
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous is! Authenticated && current is Authenticated,
          listener: (context, state) {
            context.read<DashboardBloc>().add(LoadDashboardSummary());
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: AppColors.primaryBlack,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your market activity at a glance.',
                      style: TextStyle(
                        color: AppColors.mediumGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const UserBanner(),
                    ),
                    const SizedBox(height: 20),
                    AppPrimaryButton(
                      label: 'New Inspection',
                      iconData: Icons.add,
                      onPressed: () =>
                          context.pushNamed(Routes.newInspectionName),
                    ),
                    const SizedBox(height: 12),
                    const ViewInspectionsBtn(),
                    const SizedBox(height: 28),
                    const Text(
                      'This week’s overview',
                      style: TextStyle(
                        color: AppColors.primaryBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const WeeklyOverviewSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
