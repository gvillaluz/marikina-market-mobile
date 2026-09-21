import 'package:marikina_market_mobile/core/shared/domain/enums/account_status.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/domain/enums/role.dart';

class UserModel {
  final int userId;
  final String username;
  final String lastName;
  final String firstName;
  final String? middleName;
  final String email;
  final DateTime dateOfBirth;
  final String mobileNumber;
  final String address;
  final Role role;
  final AccountStatus status;
  final String? profileUrl;
  final DateTime createdAt;
  final bool mustChangePassword;

  UserModel({
    required this.userId,
    required this.username,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.email,
    required this.dateOfBirth,
    required this.mobileNumber,
    required this.address,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.mustChangePassword,
    required this.profileUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as int,
      username: json['username'] as String,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      mobileNumber: json['mobile_number'] as String,
      address: json.containsKey('address')
          ? json['address'] as String
          : '${json['house_number'] as String} ${json['street'] as String} ${json['barangay'] as String} ${json['city'] as String} City',
      role: Role.fromValue(json['role'] as String),
      status: AccountStatus.fromValue(json['status'] as String),
      profileUrl: json['profile_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      mustChangePassword: json['must_changed_password'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'last_name': lastName,
      'first_name': firstName,
      'middle_name': middleName,
      'email': email,
      'date_of_birth':
          '${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}',
      'mobile_number': mobileNumber,
      'address': address,
      'role': role.value,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'profile_url': profileUrl,
      'must_changed_password': mustChangePassword,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.userId,
      username: user.username,
      lastName: user.lastName,
      firstName: user.firstName,
      middleName: user.middleName,
      email: user.email,
      dateOfBirth: user.dateOfBirth,
      mobileNumber: user.mobileNumber,
      address: user.address,
      role: user.role,
      status: user.status,
      profileUrl: user.profileUrl,
      createdAt: user.createdAt,
      mustChangePassword: user.mustChangePassword,
    );
  }

  User toEntity() {
    return User(
      userId: userId,
      username: username,
      lastName: lastName,
      firstName: firstName,
      middleName: middleName,
      email: email,
      dateOfBirth: dateOfBirth,
      mobileNumber: mobileNumber,
      address: address,
      role: role,
      status: status,
      profileUrl: profileUrl,
      createdAt: createdAt,
      mustChangePassword: mustChangePassword,
    );
  }
}
