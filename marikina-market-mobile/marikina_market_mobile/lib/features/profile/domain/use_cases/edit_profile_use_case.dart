import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/usecases/usecase.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:marikina_market_mobile/features/profile/domain/repositories/profile_repository.dart';

class EditProfileUseCase extends UseCase<User, EditProfileParams> {
  final ProfileRepository _repository;
  final AuthRepository _authRepository;

  EditProfileUseCase(this._repository, this._authRepository);

  @override
  Future<Result<User>> call(EditProfileParams params) async {
    if (params.firstName.trim().isEmpty || params.lastName.trim().isEmpty) {
      return Result.failure(ValidationFailure('First name and Last name cannot be empty.'));
    }

    var updatedUserResult = await _repository.updateUserInfo(
      params.userId, 
      params.lastName, 
      params.firstName, 
      params.middleName
    );

    if (updatedUserResult is ResultFailure<User>) return Result.failure(updatedUserResult.failure);

    var updatedUser = (updatedUserResult as Success<User>).data;

    var storeUpdatedUserResult = await _authRepository.storeUserInfo(updatedUser);

    if (storeUpdatedUserResult is ResultFailure<Unit>) {
      return Result.failure(storeUpdatedUserResult.failure);
    }

    return Result.success(updatedUser);
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
    this.middleName
  });
}