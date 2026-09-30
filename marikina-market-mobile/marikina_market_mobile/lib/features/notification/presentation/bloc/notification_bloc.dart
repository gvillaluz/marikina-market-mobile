import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/notification/domain/entities/notification_summary.dart';
import 'package:marikina_market_mobile/features/notification/domain/use_cases/load_notifications_use_case.dart';
import 'package:marikina_market_mobile/features/notification/domain/use_cases/mark_as_read_use_case.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_event.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final LoadNotificationsUseCase loadNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  List<NotificationSummary> _notifications = [];
  String _filter = 'All';
  bool _hasMore = false;
  bool _isLoadingMore = false;
  int _listRequestId = 0;

  NotificationBloc({
    required this.loadNotificationsUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter emit,
  ) async {
    final isLoadMore = event.offset > 0;
    if (isLoadMore) {
      final current = state;
      if (_isLoadingMore ||
          current is! NotificationLoaded ||
          !current.hasMore ||
          !_hasMore ||
          event.offset != _notifications.length ||
          event.filter != _filter) {
        return;
      }
      _isLoadingMore = true;
      emit(current.copyWith(isLoadingMore: true, clearErrorMessage: true));
    } else {
      final filterChanged = event.filter != _filter;
      _filter = event.filter;
      _listRequestId++;
      _isLoadingMore = false;
      if (filterChanged) {
        _notifications = [];
        _hasMore = false;
      }
      if (_notifications.isEmpty) {
        emit(NotificationLoading());
      } else {
        emit(NotificationLoaded(_notifications, _hasMore, isRefreshing: true));
      }
    }

    final requestId = _listRequestId;
    final result = await loadNotificationsUseCase(event.offset, event.filter);
    if (requestId != _listRequestId) return;

    switch (result) {
      case Success(:final data):
        _notifications = event.offset == 0
            ? data.items
            : [..._notifications, ...data.items];
        _hasMore = data.hasMore && data.items.isNotEmpty;
        _isLoadingMore = false;
        emit(NotificationLoaded(_notifications, _hasMore));
        break;

      case ResultFailure(failure: final failure):
        _isLoadingMore = false;
        if (_notifications.isEmpty) {
          emit(NotificationFailed(failure.message));
        } else {
          emit(
            NotificationLoaded(
              _notifications,
              _hasMore,
              errorMessage: failure.message,
              isLoadMoreError: isLoadMore,
            ),
          );
        }
    }
  }

  Future<void> _onMarkAsRead(MarkAsRead event, Emitter emit) async {
    if (state is NotificationLoaded) {
      final current = state as NotificationLoaded;
      final notifications = current.notifications;

      final updatedNotifications = notifications.map((n) {
        if (n.notificationId != event.id) return n;

        return NotificationSummary(
          notificationId: n.notificationId,
          enforcerId: n.enforcerId,
          ticketId: n.ticketId,
          controlNumber: n.controlNumber,
          tradeName: n.tradeName,
          marketSection: n.marketSection,
          penaltyType: n.penaltyType,
          totalFineAmount: n.totalFineAmount,
          dueDate: n.dueDate,
          status: n.status,
          message: n.message,
          isRead: true,
          createdAt: n.createdAt,
        );
      }).toList();

      _notifications = updatedNotifications;
      emit(current.copyWith(notifications: updatedNotifications));
    }

    await markAsReadUseCase(event.id);
  }
}
