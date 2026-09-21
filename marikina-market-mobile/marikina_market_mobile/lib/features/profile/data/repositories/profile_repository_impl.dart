import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:marikina_market_mobile/features/profile/data/cache_manager/avatar_cache_manager.dart';
import 'package:marikina_market_mobile/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:marikina_market_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;
  ProfileRepositoryImpl(this.remoteDataSource, this.authRepository);

  @override
  Future<Result<User>> updateUserInfo(
    int userId,
    String lastName,
    String firstName,
    String? middleName,
  ) async {
    try {
      final userModel = await remoteDataSource.updateUser(
        userId,
        lastName,
        firstName,
        middleName,
      );

      await authRepository.storeUserInfo(userModel.toEntity());

      return Result.success(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<Result<Unit>> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword,
  ) async {
    try {
      await remoteDataSource.changeUserPassword(
        userId,
        currentPassword,
        newPassword,
        confirmNewPassword,
      );
      return Result.success(unit);
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<Result<User>> changePhoto(XFile file) async {
    try {
      final userModel = await remoteDataSource.changePhoto(file);

      if (userModel.profileUrl != null && userModel.profileUrl!.isNotEmpty) {
        await AvatarCacheManager.instance.removeFile('user_avatar');

        await AvatarCacheManager.instance.downloadFile(
          userModel.profileUrl!,
          key: 'user_avatar',
        );
      }

      await authRepository.storeUserInfo(userModel.toEntity());

      return Result.success(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<Result<User>> removePhoto() async {
    try {
      final userModel = await remoteDataSource.removePhoto();

      await AvatarCacheManager.instance.removeFile('user_avatar');

      await authRepository.storeUserInfo(userModel.toEntity());

      return Result.success(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }
}
