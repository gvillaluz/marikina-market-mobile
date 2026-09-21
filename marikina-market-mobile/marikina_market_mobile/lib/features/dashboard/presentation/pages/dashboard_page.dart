import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserBanner(),

                const SizedBox(height: 20),

                AppPrimaryButton(
                  label: 'New Inspection',
                  iconData: Icons.add,
                  onPressed: () => context.pushNamed(Routes.newInspectionName),
                ),

                const SizedBox(height: 20),

                const ViewInspectionsBtn(),

                const SizedBox(height: 30),

                const Text(
                  'THIS WEEK\'S OVERVIEW',
                  style: TextStyle(fontSize: 16, color: AppColors.primaryBlack),
                ),

                const SizedBox(height: 10),

                const WeeklyOverviewSection(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
