import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_breakdown_item.dart';

class DuplicateWarningDialog extends StatelessWidget {
  final List<FineBreakdownItem> duplicateOrdinances;
  
  const DuplicateWarningDialog({
    required this.duplicateOrdinances,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withValues(alpha: .35),
            borderRadius: BorderRadius.circular(50)
          ),
          child: Icon(
            Icons.description_outlined,
            size: 40,
            color: AppColors.secondaryYellow,
          ),
        ),
      ),
      title: const Text(
        'Open Ticket(s) Found',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ), 
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'The vendor already has an active ticket for the following ordinance(s):',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10,),

          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.lightGrey,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < duplicateOrdinances.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGrey,
                    ),
                  ListTile(
                    dense: true,
                    title: Text(
                      duplicateOrdinances[i].ordinanceNo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      duplicateOrdinances[i].ordinanceCode,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            onPressed: () {
              context.pop();
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            }, 
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppColors.primaryLight
              ),
            )
          ),
        )
      ],
    );
  }
}