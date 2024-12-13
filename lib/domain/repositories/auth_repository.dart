import 'package:treveler/domain/entities/my_user.dart';
import 'package:treveler/domain/entities/result.dart';

abstract class AuthRepository {
  Future<Result<MyUser>> loginUser(String email, String password);

  Future<Result<MyUser>> registerUser(String email, String password);

  Future<Result<void>> removeAccount();

  Future<Result<void>> sendCode(String email);

  Future<Result<void>> verifyCode(String email, String code);

  Future<Result<void>> changePasswordWithCode(String email, String code, String password);

  Future<void> storeUserToken(String token);

  Future<void> deleteUserToken();

  Future<String?> getUserToken();

  Future<bool> checkSession();
}
