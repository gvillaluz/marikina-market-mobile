import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/sync_status_filter.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';

class FilterRow extends StatefulWidget {
  const FilterRow({
    super.key,
  });

  @override
  State<FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  int ticketTypeSelected = 1;
  int ticketStatusSelected = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 5,
            children: ViolationType.values.asMap().entries.map((entry) {
              final isSelected = entry.key + 1 == ticketTypeSelected;

              return ChoiceChip(
                label: Text(entry.value.value), 
                selected: isSelected,
                
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryLight : AppColors.primaryBlack
                ),

                selectedColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                showCheckmark: false,

                onSelected: (bool selected) {
                  setState(() {
                    ticketTypeSelected = entry.key + 1;
                  });
                },
              );
            }).toList()
          ),
          Wrap(
            spacing: 5,
            children: SyncStatusFilter.values.asMap().entries.map((entry) {
              final isSelected = entry.key + 1 == ticketStatusSelected;

              return ChoiceChip(
                label: Text(entry.value.value), 
                selected: isSelected,

                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryLight : AppColors.primaryBlack
                ),

                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                showCheckmark: false,

                onSelected: (bool selected) {
                  setState(() {
                    ticketStatusSelected = entry.key + 1;
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}