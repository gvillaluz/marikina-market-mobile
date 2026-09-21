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
            fontWeight: FontWeight.bold,
            letterSpacing: .7,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Filters(
                      filterOption: selectedOption,
                      onChange: (option) =>
                          setState(() => selectedOption = option),
                    ),
                  ]),
                ),
              ),

              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return SliverToBoxAdapter(
                      child: NotificationListSkeleton(),
                    );
                  }

                  if (state is NotificationLoaded) {
                    return SliverToBoxAdapter(
                      child: NotificationList(
                        notifications: state.notifications,
                        onRead: (id) => context.read<NotificationBloc>().add(
                          MarkAsRead(id),
                        ),
                      ),
                    );
                  }

                  if (state is NotificationFailed) {
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_paused,
                            color: AppColors.lightGrey,
                            size: 60,
                          ),
                          Divider(),
                          const Text(
                            'Failed',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'You currently have no notifications. We will notify you of the ticket changes.',
                          ),
                        ],
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
