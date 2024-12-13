import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/my_user.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<MyUser>> loginUser(String email, String password);

  Future<ApiResult<MyUser>> registerUser(String email, String password);

  Future<ApiResult<void>> removeAccount();

  Future<ApiResult<void>> sendCode(String email);

  Future<ApiResult<void>> verifyCode(String email, String code);

  Future<ApiResult<void>> changePasswordWithCode(String email, String code, String password);

  Future<bool> checkSession(String token);
}
