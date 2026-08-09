import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:marikina_market_mobile/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:marikina_market_mobile/features/auth/data/models/user_model.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  });

  @override
  Future<Result<User?>> checkAuth() async {
    try {
      final authTokens = await localDataSource.getTokens();

      final sessionRecoverable = authTokens.refreshTokenExpiration.isAfter(DateTime.now());
      if (!sessionRecoverable) return Result.success(null);

      final userModel = await localDataSource.getUser();

      return Result.success(userModel.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Result<User>> loginUser(String username, String password) async {
    try {
      final authLoginTokens = await remoteDataSource.login(username, password);
      await localDataSource.storeTokens(authLoginTokens);

      final user = await remoteDataSource.getUser();
      await localDataSource.storeUser(user);

      return Result.success(user.toEntity());
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on CacheException catch (e) {
      await localDataSource.removeUser();
      return Result.failure(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }
  
  @override
  Future<Result<Unit>> storeUserInfo(User user) async {
    try {
      await localDataSource.storeUser(UserModel.fromEntity(user));
      return Result.success(unit);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Result<Unit>> logoutUser() async {
    try {
      await localDataSource.removeUser();
      return Result.success(unit);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(e.message));
    }
  }
  
  @override
  Future<Result<User>> mandatoryChangePassword(int userId, String currentPassword, String newPassword, String confirmNewPassword) async {
    try {
      await remoteDataSource.changePassword(userId, currentPassword, newPassword, confirmNewPassword);

      final user = await localDataSource.getUser();
      
      final newUser = UserModel(
        userId: user.userId, 
        username: user.username, 
        firstName: user.firstName, 
        lastName: user.lastName, 
        middleName: user.middleName,
        email: user.email, 
        role: user.role, 
        status: user.status, 
        createdAt: user.createdAt, 
        mustChangePassword: false
      );

      await localDataSource.storeUser(newUser);

      return Result.success(newUser.toEntity());
    } on TokenExpiredException catch (e) {
      return Result.failure(TokenValidationFailure(e.message));
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
  Future<Result<Unit>> refreshTokens() async {
    try {
      final tokens = await localDataSource.getTokens();
      final freshTokens = await remoteDataSource.refreshAuthTokens(tokens.refreshToken);
      await localDataSource.storeTokens(freshTokens);

      return Result.success(unit);
    } on CacheException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Result.failure(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    }
  }
}