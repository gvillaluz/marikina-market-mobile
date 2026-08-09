import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/router/app_routes.dart';
import 'package:marikina_market_mobile/core/router/router_refresh_bloc.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';

class AppRouter {
  final AuthBloc authBloc;
  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final loc = state.matchedLocation;

      final isGoingToSplash = loc == Routes.splash;
      final isGoingToLogin = loc == Routes.login;
      final isGoingToMandatoryPass = loc == Routes.mandatoryChangePassword;

      if (authState is AuthInitial || authState is AuthLoading) {
        return isGoingToSplash ? null : Routes.splash;
      }

      final isUnauthenticated = authState is Unauthenticated || 
                                authState is AuthLogoutSuccess;

      if (isUnauthenticated) return isGoingToLogin ? null : Routes.login;

      if (authState is Authenticated) {
        if (authState.user.mustChangePassword) {
          return isGoingToMandatoryPass ? null : Routes.mandatoryChangePassword;
        }

        if (isGoingToLogin || isGoingToSplash || isGoingToMandatoryPass) {
          return Routes.dashboard;
        }
        return null;
      }

      return null;
    },
    routes: appRoutes
  );
}