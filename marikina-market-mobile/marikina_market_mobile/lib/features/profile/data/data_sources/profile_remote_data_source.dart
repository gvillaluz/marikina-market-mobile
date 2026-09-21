import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/network/client.dart';
import 'package:marikina_market_mobile/core/utils/file_compressor_util.dart';
import 'package:marikina_market_mobile/features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateUser(
    int userId,
    String lastName,
    String firstName,
    String? middleName,
  );

  Future<void> changeUserPassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  );

  Future<UserModel> changePhoto(XFile file);
  Future<UserModel> removePhoto();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> updateUser(
    int userId,
    String lastName,
    String firstName,
    String? middleName,
  ) async {
    try {
      final response = await apiClient.post(
        '/user/profile',
        data: {
          'user_id': userId,
          'last_name': lastName,
          'first_name': firstName,
          'middle_name': middleName,
        },
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw UnauthorizedException(
          e.response?.data ?? 'Failed to update information.',
        );
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
  Future<void> changeUserPassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    try {
      await apiClient.post(
        '/auth/change-password',
        data: {
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw UnauthorizedException(
          e.response?.data ??
              'Failed to change password. Please try again later.',
        );
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
  Future<UserModel> changePhoto(XFile file) async {
    try {
      final compressedPhoto = await compressImage(File(file.path));

      final multipartFile = await MultipartFile.fromFile(
        compressedPhoto.path,
        filename: file.name,
      );

      final formData = FormData.fromMap({'file': multipartFile});

      final response = await apiClient.put(
        '/user/change-photo',
        data: formData,
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw UnauthorizedException(
          e.response?.data ?? 'Unable to change photo.',
        );
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
  Future<UserModel> removePhoto() async {
    try {
      final response = await apiClient.put('/user/remove-photo');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw UnauthorizedException(
          e.response?.data ?? 'Unable to remove photo.',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
}
