import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/utils/unit.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokensUseCase {
  final AuthRepository _repository;
  RefreshTokensUseCase(this._repository);
  
  Future<Result<Unit>> call() async {
    return await _repository.refreshTokens();
  }
}