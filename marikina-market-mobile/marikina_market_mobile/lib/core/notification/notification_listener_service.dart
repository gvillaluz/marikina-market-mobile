// core/notifications/notification_listener_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'in_app_notification_overlay.dart';

class NotificationListenerService {
  final GoRouter router;

  NotificationListenerService(this.router);

  void init() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  Future<void> handleInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToTicket(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final overlayState = router.routerDelegate.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    InAppNotificationOverlay.show(
      overlayState,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      onTap: () => _navigateToTicket(message),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    _navigateToTicket(message);
  }

  void _navigateToTicket(RemoteMessage message) {
    final ticketId = message.data['ticketId'];
    if (ticketId != null) {
      router.push('/ticket-detail/$ticketId');
    }
  }
}