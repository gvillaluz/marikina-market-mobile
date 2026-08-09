import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class BackBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const BackBtn({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          
          iconSize: 25,

          elevation: 0,

          backgroundColor: Colors.grey.shade100,
          foregroundColor: AppColors.mediumGrey.withValues(alpha: 0.70),

          side: BorderSide(
            color: AppColors.mediumGrey.withValues(alpha: 0.70)
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          ),

          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          'Back'
        ),
      ),
    );
  }
}