import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class FormTypeOption extends StatelessWidget {
  final ViolationType selectedType;
  final ViolationType formType;
  final ValueChanged<ViolationType> onChange;

  const FormTypeOption({
    required this.selectedType,
    required this.formType,
    required this.onChange,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedType == formType;

    return GestureDetector(
      onTap: () => onChange(formType),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : null,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        child: Text(
          formType.value,
          style: const TextStyle(
            fontSize: 16
          ),
        ),
      ),
    );
  }
}