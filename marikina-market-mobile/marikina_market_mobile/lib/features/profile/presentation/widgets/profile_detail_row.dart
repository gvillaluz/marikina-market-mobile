import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/account_status.dart';

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final AccountStatus? status;

  const ProfileDetailRow({
    super.key,
    required this.label,
    this.value,
    this.status
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == AccountStatus.active;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label
          ),
          if (value != null) Text(value ?? ''),
          if (status != null) 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isActive ? AppColors.secondaryGreen : AppColors.secondaryRed,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                spacing: 3,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.primaryGreen : AppColors.primaryRed
                    ),
                  ),
                  Text(
                    status!.value,
                    style: TextStyle(
                      color: isActive ? AppColors.primaryGreen : AppColors.primaryRed
                    ),
                  )
                ],
              ),
            )
        ],
      ), 
    );
  }
}