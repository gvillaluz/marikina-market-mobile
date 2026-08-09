import 'package:marikina_market_mobile/core/errors/failure.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/usecases/usecase.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUserUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;
  LoginUserUseCase(this._repository);

  @override
  Future<Result<User>> call(LoginParams params) async {
    if (params.username.trim().isEmpty || params.password.isEmpty) {
      return Result.failure(ValidationFailure('Username and password are required.'));
    }

    return await _repository.loginUser(params.username, params.password);
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password
  });
}