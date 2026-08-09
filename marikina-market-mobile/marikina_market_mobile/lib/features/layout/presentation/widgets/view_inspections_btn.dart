import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';

class ViewInspectionsBtn extends StatelessWidget {
  const ViewInspectionsBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),

          foregroundColor: AppColors.primary,
          iconSize: 25,

          side: BorderSide(
            color: AppColors.primary,
            width: 2
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          )
        ),
        onPressed: () {
          context.go(Routes.inspetions);
        }, 
        icon: Icon(Icons.search),
        label: const Text('View My Inspections'),
      ),
    );
  }
}