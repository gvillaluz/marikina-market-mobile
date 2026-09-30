import 'package:marikina_market_mobile/features/tickets/domain/entities/ticket_receipt_proof.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';

class TicketReceiptProofModel {
  final int ticketId;
  final PenaltyType penaltyType;
  final List<String> proofUrls;

  const TicketReceiptProofModel({
    required this.ticketId,
    required this.penaltyType,
    required this.proofUrls,
  });

  factory TicketReceiptProofModel.fromJson(Map<String, dynamic> json) {
    return TicketReceiptProofModel(
      ticketId: json['ticket_id'] as int,
      penaltyType: PenaltyType.fromValue(json['penalty_type'] as String),
      proofUrls: List<String>.from(json['proof_urls'] as List<dynamic>),
    );
  }

  TicketReceiptProof toEntity() => TicketReceiptProof(
    ticketId: ticketId,
    penaltyType: penaltyType,
    proofUrls: proofUrls,
  );
}
