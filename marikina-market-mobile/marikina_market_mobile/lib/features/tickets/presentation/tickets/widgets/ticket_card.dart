import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';

class TicketCard extends StatelessWidget {
  final TicketSummary ticketSummary;

  const TicketCard({
    super.key,
    required this.ticketSummary
  });

  Color _getContainerColor() {
    switch (ticketSummary.ticketStatus) {
      case TicketStatus.active: return AppColors.secondaryGreen;
      case TicketStatus.paid: return AppColors.tertiary;
      case TicketStatus.voidType: return AppColors.secondaryRed;
      case TicketStatus.disputed: return AppColors.tertiaryYellow; 
    }
  }

  Color _getStatusColor() {
    switch (ticketSummary.ticketStatus) {
      case TicketStatus.active: return AppColors.primaryGreen;
      case TicketStatus.paid: return AppColors.primary;
      case TicketStatus.voidType: return AppColors.primaryRed;
      case TicketStatus.disputed: return AppColors.secondaryYellow; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ticketSummary.isOverDue ? AppColors.primaryRed : AppColors.lightGrey,
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTROL NO.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.lightGrey
                    ),
                  ),
                  Text(
                    '#${ticketSummary.controlNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getContainerColor(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _getStatusColor(),
                    width: 1
                  )
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle
                      ),
                    ),
                    Text(
                      ticketSummary.ticketStatus.value,
                      style: TextStyle(
                        color: _getStatusColor()
                      ),
                    ),
                  ],
                )
              )
            ],
          ),

          const SizedBox(height: 20,),

          Text(
            ticketSummary.businessName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),

          Text(
            '${ticketSummary.marketSection} \u2022 ${ticketSummary.stallNumber}',
          ),

          Divider(
            thickness: 1,
            color: AppColors.lightGrey,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),

                  const SizedBox(width: 10,),

                  Text(
                    DateTimeFormatter.getDateTime(ticketSummary.createdAt),
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                ],
              ),
              
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 16
                    )
                  ),
                  onPressed: () {
                    context.goNamed(Routes.ticketDetailName, pathParameters: {
                      'controlNumber': ticketSummary.businessName
                    });
                  }, 
                  child: const Text(
                    'View Details',
                  )
                ),
            ],
          ),

          if (ticketSummary.isOverDue) ...[
            Text(
              '\u2022 Overdue: ${DateTimeFormatter.getDate(ticketSummary.overDueDate)}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ],
      ),
    );
  }
}