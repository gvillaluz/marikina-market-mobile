import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class Filters extends StatelessWidget {
  final String filterOption;
  final ValueChanged<String> onChange;
  const Filters({
    required this.filterOption,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        spacing: 10,
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: filterOption == 'All',
            labelStyle: TextStyle(
              color: filterOption == 'All'
                  ? AppColors.primaryLight
                  : AppColors.primaryBlack,
            ),

            selectedColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            showCheckmark: false,

            onSelected: (_) => onChange('All'),
          ),
          ChoiceChip(
            label: const Text('Unread'),
            selected: filterOption == 'Unread',

            labelStyle: TextStyle(
              color: filterOption == 'Unread'
                  ? AppColors.primaryLight
                  : AppColors.primaryBlack,
            ),

            selectedColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            showCheckmark: false,

            onSelected: (_) => onChange('Unread'),
          ),
        ],
      ),
    );
  }
}
