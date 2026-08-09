import 'package:dio/dio.dart';
import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/network/client.dart';
import 'package:marikina_market_mobile/features/auth/data/models/auth_tokens.dart';
import 'package:marikina_market_mobile/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> login(String username, String password);
  Future<UserModel> getUser();
  Future<void> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword
  );
  Future<AuthTokens> refreshAuthTokens(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthTokens> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login-mobile',
        data: {
          'username': username,
          'password': password
        }
      );

      return AuthTokens.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw UnauthorizedException(e.response?.data['message'] ?? 'Invalid username or password.');

      if (e.response?.statusCode == 423) throw UnauthorizedException(e.response?.data['message'] ?? 'Too many attempts. Please try again later.');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await apiClient.post('/auth/me');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw UnauthorizedException(e.response?.data['message'] ?? 'Invalid username or password.');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
  
  @override
  Future<void> changePassword(int userId, String currentPassword, String newPassword, String confirmNewPassword) async {
    try {
      await apiClient.post(
        '/auth/mandatory-change-password',
        data: {
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword
        }
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw TokenExpiredException("Invalid Session.");

      if (e.response?.statusCode == 400) {
      throw UnauthorizedException(e.response?.data['message'] ?? 'Invalid current or new password.');
    }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
  
  @override
  Future<AuthTokens> refreshAuthTokens(String refreshToken) async {
    try {
      final response = await apiClient.post(
        '/auth/refresh',
        data: {
          'refresh_token': refreshToken
        },
        options: Options(extra: {'skipAuth': true})
      );

      return AuthTokens.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw UnauthorizedException(e.response?.data['message'] ?? 'Session expired.');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
}