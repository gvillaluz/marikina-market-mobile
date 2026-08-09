import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/layout/presentation/widgets/root_navigation_bar.dart';

class RootScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const RootScreen({required this.navigationShell, super.key});

  static const List<String> _titles = [
    'Dashboard',
    'Inspections',
    'Tickets',
    'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: navigationShell,
      bottomNavigationBar: RootNavigationBar(navigationShell: navigationShell),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 55,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image.asset(
          'assets/logo/org_logo.png',
          height: 32,
          width: 32,
          fit: BoxFit.contain,
        ),
      ),

      title: Text(
        _titles[navigationShell.currentIndex],
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: .7
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {}, 
          icon: Icon(
            Icons.notifications_outlined,
            size: 30,
            color: AppColors.primary,
          )
        ),
        const SizedBox(width: 10,)
      ],
    );
  }
}