abstract class AuthLocalDataSource {
  Future<void> storeUserToken(String token);

  Future<String?> getUserToken();

  Future<void> deleteUserToken();
}
