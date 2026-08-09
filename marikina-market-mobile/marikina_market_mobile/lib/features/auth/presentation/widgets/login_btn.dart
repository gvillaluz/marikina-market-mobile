import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class AuthBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthBtn({
    required this.onPressed,
    required this.isLoading,
    required this.label,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6)
            ),

            foregroundColor: AppColors.primaryLight,

            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            textStyle: const TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold
            )
          ),
          onPressed: onPressed, 
          child: isLoading 
            ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: AppColors.primaryLight,
                ),
            ) 
            : Text(
              label,
            )
        ),
      ),
    );
  }
}