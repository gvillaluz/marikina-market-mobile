import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/di/dependency_injection.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:marikina_market_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:marikina_market_mobile/features/auth/presentation/pages/mandatory_change_password_page.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:marikina_market_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:marikina_market_mobile/features/layout/presentation/pages/root_screen.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:marikina_market_mobile/features/notification/presentation/bloc/notification_event.dart';
import 'package:marikina_market_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/profile/presentation/pages/change_password_page.dart';
import 'package:marikina_market_mobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:marikina_market_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:marikina_market_mobile/features/splash/presentation/pages/splash_screen.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/duplicate_ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/inspection_form_data.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/pages/add_new_inspection_page.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/pages/inspections_page.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/pages/new_inspection_preview_page.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/pages/ticket_detail_page.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/pages/tickets_page.dart';

final appRoutes = [
  GoRoute(
    name: Routes.loginName,
    path: Routes.login,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const LoginPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    name: Routes.mandatoryChangePasswordName,
    path: Routes.mandatoryChangePassword,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const MandatoryChangePasswordPage(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    ),
  ),
  GoRoute(
    name: Routes.splashName,
    path: Routes.splash,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SplashScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  ),
  GoRoute(
    name: Routes.ticketDetailName,
    path: Routes.ticketDetail,
    redirect: (context, state) {
      final ticketId = int.tryParse(state.pathParameters['ticketId'] ?? '');

      if (ticketId == null) return Routes.inspectionsName;

      return null;
    },
    pageBuilder: (context, state) {
      final ticketId = int.tryParse(state.pathParameters['ticketId'] ?? '');
      final droppedOrdinances = state.extra != null
          ? (state.extra as List).cast<DuplicateOrdinance>()
          : null;

      return CupertinoPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (_) => sl<TicketBloc>()..add(LoadTicketDetail(ticketId!)),
          child: TicketDetailPage(droppedOrdinances: droppedOrdinances),
        ),
      );
    },
  ),
  GoRoute(
    name: Routes.editProfileName,
    path: Routes.editProfile,
    pageBuilder: (context, state) {
      final user = state.extra as User;

      return CupertinoPage(
        child: BlocProvider(
          create: (_) => sl<ProfileBloc>(),
          child: EditProfilePage(user: user),
        ),
      );
    },
  ),
  GoRoute(
    name: Routes.changePasswordName,
    path: Routes.changePassword,
    pageBuilder: (context, state) {
      final user = state.extra as User;

      return CupertinoPage(
        child: BlocProvider(
          create: (_) => sl<ProfileBloc>(),
          child: ChangePasswordPage(user: user),
        ),
      );
    },
  ),
  GoRoute(
    name: Routes.newInspectionName,
    path: Routes.newInspection,
    pageBuilder: (context, state) {
      final authState = sl<AuthBloc>().state;

      final user = (authState as Authenticated).user;

      return CupertinoPage(
        child: BlocProvider(
          create: (_) => sl<InspectionBloc>(),
          child: AddNewInspectionPage(user: user),
        ),
      );
    },
    routes: [
      GoRoute(
        name: Routes.newInspectionPreviewName,
        path: Routes.newInspectionPreview,
        pageBuilder: (context, state) {
          final formData = state.extra as InspectionFormData;

          return CupertinoPage(
            child: BlocProvider(
              create: (_) => sl<InspectionBloc>(),
              child: NewInspectionPreviewPage(formData: formData),
            ),
          );
        },
      ),
    ],
  ),
  GoRoute(
    name: Routes.notificationsName,
    path: Routes.notifications,
    pageBuilder: (context, state) {
      return CupertinoPage(
        child: BlocProvider(
          create: (_) =>
              sl<NotificationBloc>()..add(LoadNotifications(0, 'All')),
          child: const NotificationPage(),
        ),
      );
    },
  ),
  StatefulShellRoute(
    builder: (context, state, navigationShell) =>
        RootScreen(navigationShell: navigationShell),

    navigatorContainerBuilder: (context, navigationShell, children) {
      final int currentIndex = navigationShell.currentIndex;

      return Stack(
        children: List.generate(children.length, (index) {
          final bool isCurrent = index == currentIndex;

          final Offset slideOffset;

          if (isCurrent) {
            slideOffset = Offset.zero;
          } else if (index > currentIndex) {
            slideOffset = const Offset(1.0, 0.0);
          } else {
            slideOffset = const Offset(-0.2, 0.0);
          }

          return AnimatedSlide(
            offset: slideOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
            child: Offstage(
              offstage: !isCurrent,
              child: TickerMode(enabled: isCurrent, child: children[index]),
            ),
          );
        }),
      );
    },
    branches: _shellBranches,
  ),
];

final _shellBranches = [
  StatefulShellBranch(
    routes: [
      GoRoute(
        name: Routes.dashboardName,
        path: Routes.dashboard,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<DashboardBloc>()..add(LoadDashboardSummary()),
            child: const DashboardPage(),
          );
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        name: Routes.inspectionsName,
        path: Routes.inspetions,
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                sl<InspectionBloc>()
                  ..add(LoadInspectionTickets(0, ViolationType.warning)),
            child: const InspectionsPage(),
          );
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        name: Routes.ticketsName,
        path: Routes.tickets,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<TicketBloc>()
              ..add(LoadTicketSummary(offset: 0, status: TicketStatus.pending)),
            child: const TicketsPage(),
          );
        },
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        name: Routes.profileName,
        path: Routes.profile,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => sl<ProfileBloc>(),
            child: const ProfilePage(),
          );
        },
      ),
    ],
  ),
];
