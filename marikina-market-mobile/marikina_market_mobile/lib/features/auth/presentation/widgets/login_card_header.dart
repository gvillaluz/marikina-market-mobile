import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class LoginCardHeader extends StatelessWidget {
  const LoginCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        color: AppColors.primary
      ),
      child: Column(
        spacing: 10,
        children: [
          Image.asset(
            'assets/logo/org_logo.png',
            height: 100,
            width: 100,
          ),
          const Text(
            'Marikina Public Market Inspection System',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Enforcer Access',
            style: TextStyle(
              color: Colors.white
            ),
          )
        ],
      ),
    );
  }
}