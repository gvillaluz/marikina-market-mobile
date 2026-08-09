import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/form/form_type_option.dart';

class InspectionTypeToggle extends StatelessWidget {
  final ViolationType selected;
  final ValueChanged<ViolationType> onChange;

  const InspectionTypeToggle({
    required this.selected,
    required this.onChange,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: .50),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        spacing: 5,
        children: [
          Expanded(
            child: FormTypeOption(
              selectedType: selected,
              formType: ViolationType.warning, 
              onChange: onChange
            ),
          ),
          Expanded(
            child: FormTypeOption(
              selectedType: selected,
              formType: ViolationType.ticket, 
              onChange: onChange
            ),
          )
        ],
      ),
    );
  }
}