import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/notification/domain/entities/notification_summary.dart';
import 'package:marikina_market_mobile/features/notification/presentation/widgets/notification_tile.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationSummary> notifications;
  final ValueChanged<int> onRead;

  const NotificationList({
    required this.notifications,
    required this.onRead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day;
    final todayItems = notifications.where((n) => n.createdAt.day == today);
    final earlierItems = notifications.where((n) => n.createdAt.day != today);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todayItems.isNotEmpty) ...[
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Today',
                  style: TextStyle(color: AppColors.mediumGrey, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...todayItems.map(
              (n) => NotificationTile(notification: n, onRead: onRead),
            ),
          ],

          if (earlierItems.isNotEmpty) ...[
            const Row(
              children: [
                SizedBox(width: 10),
                Text(
                  'Earlier',
                  style: TextStyle(color: AppColors.mediumGrey, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...earlierItems.map(
              (n) => NotificationTile(notification: n, onRead: onRead),
            ),
          ],

          if (notifications.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
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
                      'No Notifications to show',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'You currently have no notifications. We will notify you of the ticket changes.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
