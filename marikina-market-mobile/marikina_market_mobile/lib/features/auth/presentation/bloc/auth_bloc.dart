import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/connectivity/connectivity_status.dart';
import 'package:marikina_market_mobile/core/connectivity/cubit/connectivity_cubit.dart';
import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/check_auth_status_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/login_user_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/logout_user_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/mandatory_change_password_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/refresh_tokens_use_case.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ConnectivityCubit connectivityCubit;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LoginUserUseCase loginUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;
  final MandatoryChangePasswordUseCase mandatoryChangePasswordUseCase;
  final RefreshTokensUseCase refreshTokensUseCase;

  // ignore: unused_field
  late final StreamSubscription<ConnectivityStatus> _connectivitySubscription;
  // ignore: unused_field
  Timer? _tokenCheckTimer;

  AuthBloc({
    required this.connectivityCubit,
    required this.checkAuthStatusUseCase,
    required this.loginUserUseCase,
    required this.logoutUserUseCase,
    required this.mandatoryChangePasswordUseCase,
    required this.refreshTokensUseCase
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutUser>(_onLogoutUser);
    on<UserUpdated>(_onUserUpdated);
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
    on<RefreshTokens>(_onRefreshTokens);

    _connectivitySubscription = connectivityCubit.stream.listen((status) {
      if (status == ConnectivityStatus.online) add(RefreshTokens());
    });

    _tokenCheckTimer = Timer.periodic(
      const Duration(minutes: 14),
      (_) {
        if (connectivityCubit.state == ConnectivityStatus.online) {
          add(RefreshTokens());
        }
      }
    );

    
    add(CheckAuthStatus());
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    _tokenCheckTimer?.cancel();
    return super.close();
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await checkAuthStatusUseCase();

    switch (result) {
      case ResultFailure():
        emit(Unauthenticated(false));

      case Success(data: final user):
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(Unauthenticated(false));
        }
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoginLoading());

    final result = await loginUserUseCase(
      LoginParams(
        username: event.username, 
        password: event.password
      )
    );

    switch (result) {
      case ResultFailure(failure: UnauthorizedFailure(: final message) ||
            ValidationFailure(: final message)):
        emit(AuthInvalidCredentials(message));

      case ResultFailure(failure: NetworkFailure(: final message) ||
            ServerFailure(: final message) ||
            CacheFailure(: final message) ||
            ConflictFailure(: final message)): 
        emit(AuthConnectionError(message));

      case ResultFailure(failure: TokenValidationFailure(: final message)):
        debugPrint(message);
        emit(Unauthenticated(false));

      case Success(data: final user):
        emit(Authenticated(user: user));
    }
  }

  Future<void> _onChangePasswordSubmitted(ChangePasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthChangePasswordLoading());

    final result = await mandatoryChangePasswordUseCase(
      MandatoryChangePasswordParams(
        userId: event.userId, 
        currentPassword: event.currentPassword, 
        newPassword: event.newPassword, 
        confirmNewPassword: event.confirmNewPassword
      )
    );

    switch (result) {
      case Success():
        break;

      case ResultFailure(failure: UnauthorizedFailure(:final message)):
        debugPrint(message);
        emit(Unauthenticated(false));

      case ResultFailure():
        break;
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<AuthState> emit) async {
    final logoutResult = await logoutUserUseCase();

    switch (logoutResult) {
      case ResultFailure(failure: NetworkFailure(: final message) ||
            ServerFailure(: final message) ||
            CacheFailure(: final message)): 
        emit(AuthConnectionError(message));

      default:
        emit(Unauthenticated(event.sessionExpired));
    }
  }

  Future<void> _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) async => emit(Authenticated(user: event.user));

  Future<void> _onRefreshTokens(RefreshTokens event, Emitter<AuthState> emit) async {
    if (state is! Authenticated) return;

    final result = await refreshTokensUseCase();

    switch (result) {
      case Success():
        break;

      case ResultFailure():
        emit(Unauthenticated(false));
    }
  }
}