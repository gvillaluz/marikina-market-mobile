import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_card.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/skeleton_box.dart';

class TicketListSection extends StatelessWidget {
  const TicketListSection({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) {
        if (state is TicketLoading || state is TicketSilentLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const SkeletonBox(height: 160),
                childCount: 5,
              ),
            ),
          );
        }

        if (state is TicketsLoaded) {
          if (state.ticketSummary.isEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    border: Border.all(
                      color: AppColors.lightGrey.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No Tickets Found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'There are no active or historical tickets recorded for this vendor.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mediumGrey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == state.ticketSummary.length) {
                  return _buildFooter(state);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TicketCard(ticketSummary: state.ticketSummary[index]),
                );
              }, childCount: state.ticketSummary.length + 1),
            ),
          );
        }

        if (state is TicketError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  border: Border.all(
                    color: AppColors.primaryRed.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: .10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 32,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to Load Tickets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mediumGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(child: const SizedBox.shrink());
      },
    );
  }

  Widget _buildFooter(TicketsLoaded state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: TextButton(
            onPressed: onRetry,
            child: Text(
              state.isLoadMoreError
                  ? 'Unable to load more tickets. Try again.'
                  : 'Refresh failed. Try again.',
            ),
          ),
        ),
      );
    }
    if (!state.hasMore && state.ticketSummary.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            'Nothing follows',
            style: TextStyle(color: AppColors.mediumGrey, fontSize: 12),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
