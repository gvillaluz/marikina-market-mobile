import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/usecases/usecase.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/profile/domain/repositories/profile_repository.dart';

class EditProfileUseCase extends UseCase<User, EditProfileParams> {
  final ProfileRepository _repository;

  EditProfileUseCase(this._repository);

  @override
  Future<Result<User>> call(EditProfileParams params) async {
    if (params.firstName.trim().isEmpty || params.lastName.trim().isEmpty) {
      return Result.failure(
        ValidationFailure('First name and Last name cannot be empty.'),
      );
    }

    return await _repository.updateUserInfo(
      params.userId,
      params.lastName,
      params.firstName,
      params.middleName,
    );
  }
}

class EditProfileParams {
  final int userId;
  final String lastName;
  final String firstName;
  final String? middleName;

  EditProfileParams({
    required this.userId,
    required this.lastName,
    required this.firstName,
    this.middleName,
  });
}
