import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class SaveBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SaveBtn({
    super.key,
    required this.onPressed,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          
          iconSize: 25,

          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryLight,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          ),

          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: onPressed,
        child: isLoading ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: AppColors.primaryLight,
                ),
            ) 
            : const Text(
              'SAVE CHANGES'
            )
      ),
    );
  }
}