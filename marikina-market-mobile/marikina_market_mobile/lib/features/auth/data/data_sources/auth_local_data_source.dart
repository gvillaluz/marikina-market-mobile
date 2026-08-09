import 'dart:convert';

import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/storage/secure_storage_service.dart';
import 'package:marikina_market_mobile/features/auth/data/models/auth_tokens.dart';
import 'package:marikina_market_mobile/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthTokens> getTokens();
  Future<void> storeTokens(AuthTokens tokens);
  Future<void> storeUser(UserModel user);
  Future<UserModel> getUser();
  Future<void> removeUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;
  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<AuthTokens> getTokens() async {
    final accessToken = await storageService.getAccessToken();
    final refreshToken = await storageService.getRefreshToken();
    final refreshTokenExpiration = await storageService.getRefreshTokenExpiration();

    if (accessToken == null ||
        refreshToken == null ||
        refreshTokenExpiration == null) {
          throw CacheException('No authentication tokens.');
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      refreshTokenExpiration: DateTime.parse(refreshTokenExpiration)
    );
  }
  
  @override
  Future<void> storeTokens(AuthTokens tokens) async {
    await storageService.saveTokens(
      tokens.accessToken, 
      tokens.refreshToken, 
      tokens.refreshTokenExpiration.toIso8601String()
    );
  }
  
  @override
  Future<void> storeUser(UserModel user) async {
    await storageService.saveUser(jsonEncode(user.toJson()));
  }
  
  @override
  Future<UserModel> getUser() async {
    final userCache = await storageService.getUser();

    if (userCache == null) {
          throw CacheException('No user information stored.');
    }

    return UserModel.fromJson(jsonDecode(userCache) as Map<String, dynamic>);
  }
  
  @override
  Future<void> removeUser() async {
    await storageService.deleteUserAndToken();
  }
}