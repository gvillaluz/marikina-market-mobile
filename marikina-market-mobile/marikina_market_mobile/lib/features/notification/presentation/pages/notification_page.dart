import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_event.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_state.dart';
import 'package:marikina_market_mobile/features/notification/presentation/widgets/Filters.dart';
import 'package:marikina_market_mobile/features/notification/presentation/widgets/notification_list.dart';
import 'package:marikina_market_mobile/features/notification/presentation/widgets/notification_list_skeleton.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedOption = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: .2,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<NotificationBloc>().add(
              LoadNotifications(0, selectedOption),
            );
            await context.read<NotificationBloc>().stream.firstWhere(
              (state) =>
                  state is NotificationLoaded || state is NotificationFailed,
            );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Keep track of updates to your tickets.',
                            style: TextStyle(
                              color: AppColors.mediumGrey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Filters(
                            filterOption: selectedOption,
                            onChange: (option) {
                              setState(() => selectedOption = option);
                              context.read<NotificationBloc>().add(
                                LoadNotifications(0, option),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: const NotificationListSkeleton(),
                        ),
                      ),
                    );
                  }

                  if (state is NotificationLoaded) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: NotificationList(
                            notifications: state.notifications,
                            onRead: (id) => context
                                .read<NotificationBloc>()
                                .add(MarkAsRead(id)),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is NotificationFailed) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.notifications_paused_outlined,
                                  color: AppColors.mediumGrey,
                                  size: 44,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Notifications unavailable',
                                  style: TextStyle(
                                    color: AppColors.primaryBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.mediumGrey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () =>
                                      context.read<NotificationBloc>().add(
                                        LoadNotifications(0, selectedOption),
                                      ),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try again'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
