import 'package:flutter_test/flutter_test.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ticket_settlement_models.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';

void main() {
  group('TicketReceiptProofModel', () {
    test('parses receipt proof response', () {
      final model = TicketReceiptProofModel.fromJson({
        'ticketId': 14,
        'penaltyType': 'CashFine',
        'proofUrls': ['https://example.com/receipt.jpg'],
      });

      final entity = model.toEntity();
      expect(entity.ticketId, 14);
      expect(entity.penaltyType, PenaltyType.cashFine);
      expect(entity.proofUrls, ['https://example.com/receipt.jpg']);
    });
  });

  group('CommunityServiceProgressModel', () {
    test('parses progress and expanded entry details', () {
      final model = CommunityServiceProgressModel.fromJson({
        'ticketId': 27,
        'hoursRequired': 16,
        'hoursCompleted': 6.5,
        'hoursRemaining': 9.5,
        'completionPercentage': 40.625,
        'entries': [
          {
            'serviceDate': '2026-09-26T00:00:00',
            'hoursWorked': 4.5,
            'proofUrl': 'https://example.com/proof.jpg',
          },
        ],
      });

      final progress = model.toEntity();
      expect(progress.ticketId, 27);
      expect(progress.hoursRequired, 16);
      expect(progress.hoursCompleted, 6.5);
      expect(progress.hoursRemaining, 9.5);
      expect(progress.completionPercentage, 40.625);
      expect(progress.entries, hasLength(1));
      expect(progress.entries.single.serviceDate, DateTime(2026, 9, 26));
      expect(progress.entries.single.hoursWorked, 4.5);
      expect(progress.entries.single.proofUrl, 'https://example.com/proof.jpg');
    });
  });
}
