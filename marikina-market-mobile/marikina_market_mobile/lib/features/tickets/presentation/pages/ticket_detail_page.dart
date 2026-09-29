import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/duplicate_ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/penalty_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_detail_content.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/skeleton_box.dart';

class TicketDetailPage extends StatelessWidget {
  final List<DuplicateOrdinance>? droppedOrdinances;

  const TicketDetailPage({this.droppedOrdinances, super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        context.goNamed(Routes.inspectionsName);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(Routes.inspectionsName);
              }
            },
          ),
          title: const Text(
            'Ticket Details',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TicketBloc, TicketState>(
              listenWhen: (previous, current) {
                if (current is TicketError && current != previous) return true;
                return current is TicketDetailLoaded &&
                    current.settlementMessage != null &&
                    (previous is! TicketDetailLoaded ||
                        previous.settlementMessage !=
                            current.settlementMessage);
              },
              listener: (context, state) {
                if (state is TicketError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is TicketDetailLoaded &&
                    state.settlementMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.settlementMessage!)),
                  );
                }
              },
              builder: (context, state) {
                if (state is TicketDetailLoading) {
                  return SkeletonBox(height: 500);
                }

                if (state is TicketDetailLoaded) {
                  return TicketDetailContent(
                    ticket: state.ticket,
                    droppedOrdinances: droppedOrdinances,
                    receiptProof: state.receiptProof,
                    isReceiptSubmitted: state.isReceiptSubmitted,
                    communityServiceProgress: state.communityServiceProgress,
                    isSettlementLoading: state.isSettlementLoading,
                    isSettlementLoaded: state.isSettlementLoaded,
                    isSubmittingSettlement: state.isSubmittingSettlement,
                    onRetrySettlementLoad: () {
                      context.read<TicketBloc>().add(
                        LoadTicketSettlement(
                          ticketId: state.ticket.ticketId,
                          penaltyType:
                              state.ticket.penaltyType ?? PenaltyType.cashFine,
                        ),
                      );
                    },
                    onSubmitReceipt: (proofFile) {
                      context.read<TicketBloc>().add(
                        SubmitTicketReceiptProof(
                          ticketId: state.ticket.ticketId,
                          proofFile: proofFile,
                        ),
                      );
                    },
                    onSubmitCommunityServiceLog: (params) {
                      context.read<TicketBloc>().add(
                        SubmitCommunityServiceLog(params),
                      );
                    },
                  );
                }

                if (state is TicketError) {}

                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
