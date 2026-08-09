import 'package:marikina_market_mobile/core/shared/domain/enums/account_status.dart';
import 'package:marikina_market_mobile/features/auth/domain/enums/role.dart';

class User {
  final int userId;
  final String username;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final Role role;
  final AccountStatus status;
  final DateTime createdAt;
  final bool mustChangePassword;

  const User({
    required this.userId,
    required this.username,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.mustChangePassword
  });
}