import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User?>> checkAuth();
  Future<Result<User>> loginUser(String username, String password);
  Future<Result<Unit>> storeUserInfo(User user);
  Future<Result<User>> mandatoryChangePassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword
  );
  Future<Result<Unit>> refreshTokens();
  Future<Result<Unit>> registerDeviceToken();
  Future<Result<Unit>> logoutUser();
}