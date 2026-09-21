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
    emit(NotificationLoading());

    final result = await loadNotificationsUseCase(event.offset, event.filter);

    switch (result) {
      case Success(:final data):
        emit(NotificationLoaded(data.items, data.hasMore));
        break;

      case ResultFailure(failure: final failure):
        emit(NotificationFailed(failure.message));
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

      emit(NotificationLoaded(updatedNotifications, current.hasMore));
    }

    await markAsReadUseCase(event.id);
  }
}
