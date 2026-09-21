import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/fine_summary.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/widgets/detail_row.dart';

class SubmitConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onPressed;
  final FineSummary? fineSummary;
  final PenaltyType? penaltyType;
  final int? communityServiceHrs;
  final Severity? severity;
  final bool isTicket;

  const SubmitConfirmationBottomSheet({
    required this.onPressed,
    this.fineSummary,
    this.penaltyType,
    this.communityServiceHrs,
    this.severity,
    required this.isTicket,
    super.key,
  });

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
  );

  Color get _bgColor => switch (severity) {
    Severity.high => AppColors.secondaryRed,
    Severity.moderate => AppColors.primaryYellow,
    _ => AppColors.tertiary,
  };

  Color get _color => switch (severity) {
    Severity.high => AppColors.primaryRed,
    Severity.moderate => AppColors.secondaryYellow,
    _ => AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          if (isTicket && fineSummary != null && penaltyType != null) ...[
            Text(
              penaltyType == PenaltyType.cashFine
                  ? 'PAYMENT SUMMARY'
                  : 'TICKET SUMMARY',
              style: TextStyle(color: AppColors.primary, fontSize: 18),
            ),
            const SizedBox(height: 10),

            if (penaltyType == PenaltyType.cashFine) ...[
              DetailRow(
                label: 'TOTAL FINE DUE:',
                value: _currencyFormat.format(fineSummary?.totalPaymentAmount),
              ),
            ],

            DetailRow(label: 'PENALTY TYPE:', value: penaltyType!.label),

            if (communityServiceHrs != null && communityServiceHrs! > 0) ...[
              DetailRow(
                label: 'SERVICE HOURS:',
                value: '$communityServiceHrs hrs',
              ),
            ],

            if (severity != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('SEVERITY:'),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _bgColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      severity!.value,
                      style: TextStyle(color: _color),
                    ),
                  ),
                ],
              ),
            ],

            DetailRow(
              label: 'DUE DATE:',
              value:
                  '${DateTimeFormatter.getDate(DateTime.now().add(const Duration(days: 15)))} (15 days from issuance)',
            ),

            const Divider(),

            const Row(
              spacing: 5,
              children: [
                Icon(Icons.confirmation_num, color: AppColors.primary),
                Text(
                  'This violation ticket will be issued and recorded.',
                  style: TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ] else ...[
            const Text(
              'Confirm Warning Submission',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Please review the details. Confirming will formally submit this record.',
            ),
          ],

          const SizedBox(height: 3),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                textStyle: TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.all(15),
              ),
              onPressed: onPressed,
              icon: Icon(Icons.check_circle),
              label: Text(
                isTicket
                    ? penaltyType == PenaltyType.cashFine
                          ? 'ISSUE TICKET ${_currencyFormat.format(fineSummary?.totalPaymentAmount)}'
                          : penaltyType == PenaltyType.communityService
                          ? 'CONFIRM COMMUNITY SERVICE'
                          : 'CONFIRM BLOOD DONATION'
                    : 'CONFIRM WARNING',
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(15),
                backgroundColor: Color(0xFFEBEEF1),
                foregroundColor: Color(0xFF8F8F8F),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
