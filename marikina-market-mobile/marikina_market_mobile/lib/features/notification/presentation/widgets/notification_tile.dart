import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';
import 'package:marikina_market_mobile/features/notification/domain/entities/notification_summary.dart';

class NotificationTile extends StatefulWidget {
  final NotificationSummary notification;
  final ValueChanged<int> onRead;
  const NotificationTile({
    required this.notification,
    required this.onRead,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool isUnread = true;

  @override
  void initState() {
    super.initState();
    isUnread = !widget.notification.isRead;
  }

  Color get _containerColor => switch (widget.notification.status) {
    TicketStatus.pending => AppColors.yellowBackgroundColor,
    TicketStatus.paid => AppColors.blueBackgroundColor,
    TicketStatus.waived => AppColors.purpleBackgroundColor,
    TicketStatus.contested => AppColors.orangeBackgroundColor,
    TicketStatus.overdue => AppColors.redBackgroundColor,
    TicketStatus.cleared => AppColors.magentaBackgroundColor,
  };

  Color get _textColor => switch (widget.notification.status) {
    TicketStatus.pending => AppColors.yellowTextColor,
    TicketStatus.paid => AppColors.blueTextColor,
    TicketStatus.waived => AppColors.purpleTextColor,
    TicketStatus.contested => AppColors.orangeTextColor,
    TicketStatus.overdue => AppColors.redTextColor,
    TicketStatus.cleared => AppColors.magentaTextColor,
  };

  IconData get _icon => switch (widget.notification.status) {
    TicketStatus.pending => Icons.access_time,
    TicketStatus.paid => Icons.receipt_long,
    TicketStatus.waived => Icons.check_circle,
    TicketStatus.contested => Icons.balance,
    TicketStatus.overdue => Icons.error,
    TicketStatus.cleared => Icons.person,
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isUnread ? Color(0xFFF7F6F6) : AppColors.primaryLight,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),

      onTap: () {
        if (!widget.notification.isRead) {
          widget.onRead(widget.notification.notificationId);
          setState(() => isUnread = !isUnread);
        }

        context.pushNamed(
          Routes.ticketDetailName,
          pathParameters: {'ticketId': widget.notification.ticketId.toString()},
        );
      },
      leading: Container(
        decoration: BoxDecoration(
          color: _containerColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(_icon, color: _textColor),
      ),

      title: Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 14),
          children: [
            TextSpan(
              text: 'Ticket # ${widget.notification.controlNumber} for ',
            ),
            TextSpan(
              text: widget.notification.tradeName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' is now '),
            TextSpan(
              text: widget.notification.status.value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      subtitle: Text(
        DateTimeFormatter.getDateTime(widget.notification.createdAt),
        style: TextStyle(fontSize: 11, color: AppColors.mediumGrey),
      ),

      trailing: Text(
        'View',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
