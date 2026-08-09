import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _repository;
  const CheckAuthStatusUseCase(this._repository);

  Future<Result<User?>> call() async {
    // final tokenResult = await _repository.getStoredTokens();

    // if (tokenResult is ResultFailure<Token>) {
    //   return Result.failure(tokenResult.failure);
    // }

    // final tokens = (tokenResult as Success<Token>).data;

    // final sessionRecoverable = tokens.refreshTokenExpiration.isAfter(DateTime.now());

    // if (!sessionRecoverable) return Result.success(null);

    // final userResult = await _repository.getStoredUser();

    // if (userResult is ResultFailure<User>) {
    //   return Result.failure(CacheFailure(userResult.failure.message));
    // }

    // if (userResult is! Success<User>) { 
    //   return Result.success(null);
    // }

    // final user = userResult.data;

    // return Result.success(user);

    return await _repository.checkAuth();
  }
}