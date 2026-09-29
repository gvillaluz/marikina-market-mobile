import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class FilterRow extends StatelessWidget {
  final ViolationType typeSelected;
  final ValueChanged<ViolationType> onChange;

  const FilterRow({
    super.key,
    required this.typeSelected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FILTER BY TYPE',
          style: TextStyle(
            color: AppColors.mediumGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: ViolationType.values.map((entry) {
            final isSelected = typeSelected == entry;

            return ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : AppColors.primaryBlack,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.lightGrey.withValues(alpha: 0.7),
                ),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: 0,
                vertical: -2,
              ),
              showCheckmark: false,
              onSelected: (_) => onChange(entry),
            );
          }).toList(),
        ),
      ],
    );
  }
}
