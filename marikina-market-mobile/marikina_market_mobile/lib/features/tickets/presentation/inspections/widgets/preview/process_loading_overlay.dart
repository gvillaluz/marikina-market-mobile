import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class ProcessLoadingOverlay extends StatelessWidget {
  final String message;

  const ProcessLoadingOverlay({
    required this.message,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 5,
                backgroundColor: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Processing...',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            const Text('This will take few seconds.')
          ],
        ),
      ),
    );
  }
}