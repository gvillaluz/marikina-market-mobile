import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Result<User>> updateUserInfo(
    int userId,
    String lastName,
    String firstName,
    String? middleName,
  );

  Future<Result<Unit>> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
    String confirmNewPassword
  );
}