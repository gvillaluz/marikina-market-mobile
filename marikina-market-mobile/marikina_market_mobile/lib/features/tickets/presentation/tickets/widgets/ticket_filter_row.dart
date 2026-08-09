import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';

class TicketFilterRow extends StatefulWidget {
  const TicketFilterRow({
    super.key,
  });

  @override
  State<TicketFilterRow> createState() => _TicketFilterRowState();
}

class _TicketFilterRowState extends State<TicketFilterRow> {
  int ticketStatusSelected = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        children: TicketStatus.values.asMap().entries.map((entry) {
          final isSelected = entry.key + 1 == ticketStatusSelected;

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
                ticketStatusSelected = entry.key + 1;
              });
            },
          );
        }).toList()
      )
    );
  }
}