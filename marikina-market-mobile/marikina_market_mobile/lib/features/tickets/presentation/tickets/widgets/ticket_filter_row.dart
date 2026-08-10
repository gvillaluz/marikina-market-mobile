import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

class TicketFilterRow extends StatefulWidget {
  final TicketStatus statusSelected;
  final ValueChanged<TicketStatus> onChange;

  const TicketFilterRow({
    required this.statusSelected,
    required this.onChange,
    super.key,
  });

  @override
  State<TicketFilterRow> createState() => _TicketFilterRowState();
}

class _TicketFilterRowState extends State<TicketFilterRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        children: TicketStatus.values.map((entry) {
          final isSelected = widget.statusSelected == entry;

          return ChoiceChip(
            label: Text(entry.value), 
            selected: isSelected,
            
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primaryLight : AppColors.primaryBlack
            ),

            selectedColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            showCheckmark: false,

            onSelected: (bool selected) => widget.onChange(entry)
          );
        }).toList()
      )
    );
  }
}