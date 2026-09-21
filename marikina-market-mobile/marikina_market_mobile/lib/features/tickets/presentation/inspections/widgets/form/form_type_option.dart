import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class FormTypeOption extends StatelessWidget {
  final ViolationType selectedType;
  final ViolationType formType;
  final ValueChanged<ViolationType> onChange;
  final bool? isEnabled;

  const FormTypeOption({
    required this.selectedType,
    required this.formType,
    required this.onChange,
    this.isEnabled,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedType == formType;
    bool isWarningBlocked = isEnabled == false;
    bool canSelect = !isWarningBlocked;

    return GestureDetector(
      onTap: canSelect
        ? () => onChange(formType)
        : null,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.primary : AppColors.lightGrey.withValues(alpha: .10),
          border: Border.all(
            color: isSelected 
              ? AppColors.primary
              : isWarningBlocked
                ? AppColors.lightGrey.withValues(alpha: .50)
                : AppColors.primary,
            ),
        ),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWarningBlocked && formType == ViolationType.warning) ...[
              Icon(
                Icons.warning,
                color: AppColors.lightGrey.withValues(alpha: .50),
              )
            ],

            Text(
              formType.value,
              style: TextStyle(
                fontSize: 16,
                color: isSelected 
                  ? AppColors.primaryLight
                  : isWarningBlocked 
                    ? AppColors.lightGrey.withValues(alpha: .50)
                    : AppColors.primary 
              ),
            ),
          ],
        ),
      ),
    );
  }
}