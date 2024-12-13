import 'package:treveler/domain/entities/result.dart';

abstract class UserRepository {
  Future<void> storeEmail(String email);

  Future<void> storeUserId(int userId);

  Future<void> storePremiumUntil(DateTime? dateTime);

  Future<String?> getEmail();

  Future<int?> getUserId();

  Future<DateTime?> getPremiumUntil();

  Future<void> deleteEmail();

  Future<void> deleteUserId();

  Future<void> deletePremiumUntil();

  Future<Result<void>> selectLanguage(String language);

  Future<Result<DateTime?>> fetchPremium();
}
