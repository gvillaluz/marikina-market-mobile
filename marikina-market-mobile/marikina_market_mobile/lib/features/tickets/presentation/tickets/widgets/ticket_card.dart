import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_summary.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';

class TicketCard extends StatelessWidget {
  final TicketSummary ticketSummary;

  const TicketCard({super.key, required this.ticketSummary});

  Color get _containerColor => switch (ticketSummary.ticketStatus) {
    TicketStatus.pending => AppColors.yellowBackgroundColor,
    TicketStatus.paid => AppColors.blueBackgroundColor,
    TicketStatus.waived => AppColors.purpleBackgroundColor,
    TicketStatus.contested => AppColors.orangeBackgroundColor,
    TicketStatus.overdue => AppColors.redBackgroundColor,
    TicketStatus.cleared => AppColors.magentaBackgroundColor,
  };

  Color get _textColor => switch (ticketSummary.ticketStatus) {
    TicketStatus.pending => AppColors.yellowTextColor,
    TicketStatus.paid => AppColors.blueTextColor,
    TicketStatus.waived => AppColors.purpleTextColor,
    TicketStatus.contested => AppColors.orangeTextColor,
    TicketStatus.overdue => AppColors.redTextColor,
    TicketStatus.cleared => AppColors.magentaTextColor,
  };

  Color get _borderColor => switch (ticketSummary.ticketStatus) {
    TicketStatus.pending => AppColors.yellowBorderColor,
    TicketStatus.paid => AppColors.blueBorderColor,
    TicketStatus.waived => AppColors.purpleBorderColor,
    TicketStatus.contested => AppColors.orangeBorderColor,
    TicketStatus.overdue => AppColors.redBorderColor,
    TicketStatus.cleared => AppColors.magentaBorderColor,
  };

  @override
  Widget build(BuildContext context) {
    final isOverdue = ticketSummary.ticketStatus == TicketStatus.overdue;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOverdue ? AppColors.primaryRed : AppColors.lightGrey,
          width: 1,
        ),
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
                    style: TextStyle(fontSize: 12, color: AppColors.lightGrey),
                  ),
                  Text(
                    '#${ticketSummary.controlNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _containerColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _borderColor, width: 1),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _textColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      ticketSummary.ticketStatus.value,
                      style: TextStyle(color: _textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            ticketSummary.businessName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          Text(
            '${ticketSummary.marketSection} \u2022 ${ticketSummary.stallNumber}',
          ),

          Divider(thickness: 1, color: AppColors.lightGrey),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),

                  const SizedBox(width: 10),

                  Text(
                    DateTimeFormatter.getShortDateTime(ticketSummary.issuedAt),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),

              TextButton(
                style: TextButton.styleFrom(textStyle: TextStyle(fontSize: 16)),
                onPressed: () {
                  context.pushNamed(
                    Routes.ticketDetailName,
                    pathParameters: {
                      'ticketId': ticketSummary.ticketId.toString(),
                    },
                  );
                },
                child: const Text('View Details'),
              ),
            ],
          ),

          if (isOverdue) ...[
            Text(
              '\u2022 Overdue: ${DateTimeFormatter.getDate(ticketSummary.overDueDate)}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
