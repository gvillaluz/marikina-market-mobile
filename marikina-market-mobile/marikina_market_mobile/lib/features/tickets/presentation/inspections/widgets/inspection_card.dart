import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_ticket_summary.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';

class InspectionCard extends StatelessWidget {
  final InspectionTicketSummary ticketSummary;

  const InspectionCard({super.key, required this.ticketSummary});

  Color get _containerColor => switch (ticketSummary.severity) {
    Severity.moderate => AppColors.tertiaryYellow,
    Severity.minor => AppColors.tertiary,
    Severity.high => AppColors.secondaryRed,
    null => AppColors.lightGrey,
  };

  Color get _statusColor => switch (ticketSummary.severity) {
    Severity.moderate => AppColors.secondaryYellow,
    Severity.minor => AppColors.primary,
    Severity.high => AppColors.primaryRed,
    null => AppColors.mediumGrey,
  };

  @override
  Widget build(BuildContext context) {
    final String vendorFullName =
        '${ticketSummary.vendorLastName}, ${ticketSummary.vendorFirstName}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ticketSummary.status == TicketStatus.overdue
              ? AppColors.primaryRed
              : AppColors.lightGrey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticketSummary.ticketType.value,
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (ticketSummary.severity != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _containerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _statusColor, width: 1),
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        ticketSummary.severity!.value,
                        style: TextStyle(color: _statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          Text(
            ticketSummary.businessName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          Text(
            '${ticketSummary.marketSection} \u2022 ${ticketSummary.stallNumber} \u2022 $vendorFullName',
          ),

          const SizedBox(height: 20),

          ...ticketSummary.ordinance.map((ordinance) {
            return Text(ordinance);
          }),

          const Divider(thickness: 1, color: AppColors.lightGrey),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),

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

          if (ticketSummary.status == TicketStatus.overdue) ...[
            Text(
              '\u2022 Overdue: ${DateTimeFormatter.getDate(ticketSummary.overDueDate!)}',
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
