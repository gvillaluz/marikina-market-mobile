import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/community_service_progress.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_receipt_proof.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_settlement_section.dart';

void main() {
  testWidgets('saved receipt cannot be edited again', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettlementReceiptSection(
            ticketStatus: TicketStatus.pending,
            receiptProof: const TicketReceiptProof(
              ticketId: 1,
              penaltyType: PenaltyType.cashFine,
              proofUrls: [],
            ),
            isReceiptSubmitted: true,
            isLoaded: true,
            onRetryLoad: () {},
            onSubmit: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.text('Settlement receipt saved. This record cannot be changed.'),
      findsOneWidget,
    );
    expect(find.text('Tap to attach receipt photo'), findsNothing);
    expect(find.text('Save Receipt'), findsNothing);
  });

  testWidgets('paid ticket does not allow a receipt attachment', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettlementReceiptSection(
            ticketStatus: TicketStatus.paid,
            isLoaded: true,
            onRetryLoad: () {},
            onSubmit: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.text('This ticket is paid. Settlement details are read-only.'),
      findsOneWidget,
    );
    expect(find.text('Tap to attach receipt photo'), findsNothing);
    expect(find.text('Save Receipt'), findsNothing);
  });

  testWidgets('completed community service log is read-only', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommunityServiceLogSection(
            ticketId: 2,
            requiredHours: 8,
            ticketStatus: TicketStatus.pending,
            progress: const CommunityServiceProgress(
              ticketId: 2,
              hoursRequired: 8,
              hoursCompleted: 8,
              hoursRemaining: 0,
              completionPercentage: 100,
              entries: [],
            ),
            isLoaded: true,
            onRetryLoad: () {},
            onSubmit: (_) {},
          ),
        ),
      ),
    );

    expect(
      find.text('Required community service hours are complete.'),
      findsOneWidget,
    );
    expect(find.text('Add Service Entry'), findsNothing);
  });
}
