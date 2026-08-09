import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/features/layout/presentation/widgets/user_banner.dart';
import 'package:marikina_market_mobile/features/layout/presentation/widgets/view_inspections_btn.dart';
import 'package:marikina_market_mobile/features/layout/presentation/widgets/weekly_overview_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserBanner(),

              const SizedBox(height: 20,),

              AppPrimaryButton(
                label: 'New Inspection',
                iconData: Icons.add,
                onPressed: () => context.pushNamed(Routes.newInspectionName),
              ),

              const SizedBox(height: 20,),

              ViewInspectionsBtn(),

              const SizedBox(height: 30,),

              const Text(
                'THIS WEEK\'S OVERVIEW',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryBlack
                ),
              ),

              const SizedBox(height: 10,),

              const WeeklyOverviewSection(),

              const SizedBox(height: 20,)
            ],
          ),
        )
      ),
    );
  }
}