import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/skeleton_box.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/inspection_card.dart';

class InspectionListSection extends StatelessWidget {
  const InspectionListSection({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionBloc, InspectionState>(
      builder: (context, state) {
        if (state is InspectionLoading ||
            state is InspectionInitial ||
            state is InspectionSilentLoading) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: SkeletonBox(height: 160),
                ),
                childCount: 5,
              ),
            ),
          );
        }

        if (state is InspectionTicketsLoaded) {
          if (state.ticketSummary.isEmpty) {
            return _buildNotice(
              icon: Icons.assignment_outlined,
              title: 'No inspections found',
              message:
                  'Try changing your search or inspection type. New records will appear here.',
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 2),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'INSPECTION RECORDS',
                              style: TextStyle(
                                color: AppColors.mediumGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: Text(
                                '${state.ticketSummary.length}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InspectionCard(
                      ticketSummary: state.ticketSummary[index - 1],
                    ),
                  );
                },
                childCount: state.ticketSummary.length + 1,
              ),
            ),
          );
        }

        if (state is InspectionError) {
          return _buildNotice(
            icon: Icons.cloud_off_outlined,
            title: 'Unable to load inspections',
            message: state.message,
            isError: true,
            onRetry: onRetry,
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  SliverToBoxAdapter _buildNotice({
    required IconData icon,
    required String title,
    required String message,
    bool isError = false,
    VoidCallback? onRetry,
  }) {
    final accentColor = isError ? AppColors.primaryRed : AppColors.primary;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isError
                  ? AppColors.primaryRed.withValues(alpha: 0.25)
                  : AppColors.lightGrey.withValues(alpha: 0.55),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: accentColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.mediumGrey,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Try again'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
