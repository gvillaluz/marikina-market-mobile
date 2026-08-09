import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          
          iconSize: 25,

          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryLight,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          ),

          textStyle: TextStyle(
            fontSize: 14  
          ),
        ),
        onPressed: onPressed, 
        icon: Icon(
          iconData,
          size: 20,
        ),
        label: Text(
          label,
        ),
      )
    );
  }
}