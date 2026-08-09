import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/widgets/detail_row.dart';

class ViolatorDetailSection extends StatelessWidget {
  final String stallNumber;
  final String tradeName;
  final String fullName;
  final String address;
  final bool isTicket;

  const ViolatorDetailSection({
    required this.stallNumber,
    required this.tradeName,
    required this.fullName,
    required this.address,
    required this.isTicket,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(
              Icons.person,
              color: AppColors.primary,
            ),
            Text(
              'VIOLATOR DETAILS',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18
              ),
            )
          ],
        ),
        const SizedBox(height: 20,),
        DetailRow(label: "STALL/UNIT NO:", value: stallNumber),
        const SizedBox(height: 10,),
        DetailRow(label: "TRADE NAME:", value: tradeName),
        const SizedBox(height: 10,),
        DetailRow(label: "NAME:", value: fullName),
        if (isTicket) ...[
          const SizedBox(height: 10,),
          DetailRow(label: "ADDRESS:", value: address)
        ]
      ],
    );
  }
}