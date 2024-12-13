abstract class UserLocalDataSource {
  Future<void> storeEmail(String email);

  Future<void> storePremiumUntil(DateTime? dateTime);

  Future<void> storeUserId(int userId);

  Future<String?> getEmail();

  Future<DateTime?> getPremiumUntil();

  Future<int?> getUserId();

  Future<void> deleteEmail();

  Future<void> deletePremiumUntil();

  Future<void> deleteUserId();
}
