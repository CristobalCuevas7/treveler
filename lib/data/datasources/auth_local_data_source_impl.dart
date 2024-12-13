import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> storeUserToken(String token) async {
    await _secureStorage.write(key: 'userToken', value: token);
  }

  @override
  Future<String?> getUserToken() async {
    return await _secureStorage.read(key: 'userToken');
  }

  @override
  Future<void> deleteUserToken() async {
    await _secureStorage.delete(key: 'userToken');
  }
}
