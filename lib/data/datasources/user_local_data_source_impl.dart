import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treveler/domain/datasources/user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  UserLocalDataSourceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> storeEmail(String email) async {
    await _secureStorage.write(key: 'email', value: email);
  }

  @override
  Future<void> storeUserId(int userId) async {
    await _secureStorage.write(key: 'userId', value: userId.toString());
  }

  @override
  Future<String?> getEmail() async {
    return await _secureStorage.read(key: 'email');
  }

  @override
  Future<int?> getUserId() async {
    final userId = await _secureStorage.read(key: 'userId');
    return userId != null ? int.tryParse(userId) : null;
  }

  @override
  Future<void> deleteEmail() async {
    await _secureStorage.delete(key: 'email');
  }

  @override
  Future<void> deleteUserId() async {
    await _secureStorage.delete(key: 'userId');
  }

  @override
  Future<void> deletePremiumUntil() async {
    await _secureStorage.delete(key: 'premium_until');
  }

  @override
  Future<DateTime?> getPremiumUntil() async {
    final premiumUntilStr = await _secureStorage.read(key: 'premium_until');
    return premiumUntilStr != null ? DateTime.tryParse(premiumUntilStr) : null;
  }

  @override
  Future<void> storePremiumUntil(DateTime? dateTime) async {
    if (dateTime != null) {
      await _secureStorage.write(key: 'premium_until', value: dateTime.toIso8601String());
    } else {
      await deletePremiumUntil();
    }
  }
}
