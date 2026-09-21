import 'package:marikina_market_mobile/features/notification/domain/entities/notification_summary.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationFailed extends NotificationState {
  final String message;
  NotificationFailed(this.message);
}

class NotificationLoaded extends NotificationState {
  final List<NotificationSummary> notifications;
  final bool hasMore;
  NotificationLoaded(this.notifications, this.hasMore);
}
