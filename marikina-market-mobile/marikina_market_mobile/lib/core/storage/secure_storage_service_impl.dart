import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marikina_market_mobile/core/storage/secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage storage;
  const SecureStorageServiceImpl({required this.storage});

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _refreshKeyExpiration = 'refresh_expiration';
  static const _userKey = 'user_info_key';
  
  @override
  Future<String?> getAccessToken() async => await storage.read(key: _accessKey);
  
  @override
  Future<String?> getRefreshToken() async => await storage.read(key: _refreshKey);
  
  @override
  Future<void> saveAccessToken(String token) async => await storage.write(key: _accessKey, value: token);
  
  @override
  Future<void> saveRefreshToken(String token) async => await storage.write(key: _refreshKey, value: token);
  
  @override
  Future<String?> getRefreshTokenExpiration() async => await storage.read(key: _refreshKeyExpiration);
  
  @override
  Future<void> saveRefreshTokenExpiration(String expiration) async => await storage.write(key: _refreshKeyExpiration, value: expiration);
  
  @override
  Future<void> saveTokens(String accessToken, String refreshToken, String refreshTokenExpiration) async {
    await storage.write(key: _accessKey, value: accessToken);
    await storage.write(key: _refreshKey, value: refreshToken);
    await storage.write(key: _refreshKeyExpiration, value: refreshTokenExpiration);
  }
  
  @override
  Future<void> saveUser(String user) async {
    await storage.write(key: _userKey, value: user);
  }

  @override
  Future<String?> getUser() async => await storage.read(key: _userKey);
  
  @override
  Future<void> deleteUserAndToken() async => await storage.deleteAll();
}