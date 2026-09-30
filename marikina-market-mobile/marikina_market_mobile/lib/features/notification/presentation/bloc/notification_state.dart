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
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final bool isLoadMoreError;

  NotificationLoaded(
    this.notifications,
    this.hasMore, {
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.isLoadMoreError = false,
  });

  NotificationLoaded copyWith({
    List<NotificationSummary>? notifications,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool? isLoadMoreError,
    bool clearErrorMessage = false,
  }) {
    return NotificationLoaded(
      notifications ?? this.notifications,
      hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isLoadMoreError: isLoadMoreError ?? this.isLoadMoreError,
    );
  }
}
