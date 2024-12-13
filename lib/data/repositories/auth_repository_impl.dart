import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/auth_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart' as ApiResult;
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/entities/my_user.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Result<MyUser>> loginUser(String email, String password) async {
    return _authRemoteDataSource.loginUser(email, password).toResult();
  }

  @override
  Future<Result<MyUser>> registerUser(String email, String password) async {
    return _authRemoteDataSource.registerUser(email, password).toResult();
  }

  @override
  Future<Result<void>> removeAccount() async {
    return _authRemoteDataSource.removeAccount().toResult();
  }

  @override
  Future<Result<void>> sendCode(String email) async {
    return _authRemoteDataSource.sendCode(email).toResult();
  }

  @override
  Future<Result<void>> verifyCode(String email, String code) async {
    return _authRemoteDataSource.verifyCode(email, code).toResult();
  }

  @override
  Future<Result<void>> changePasswordWithCode(String email, String code, String password) async {
    return _authRemoteDataSource.changePasswordWithCode(email, code, password).toResult();
  }

  @override
  Future<void> storeUserToken(String token) async {
    await _authLocalDataSource.storeUserToken(token);
  }

  @override
  Future<void> deleteUserToken() async {
    await _authLocalDataSource.deleteUserToken();
  }

  @override
  Future<String?> getUserToken() async {
    return await _authLocalDataSource.getUserToken();
  }

  @override
  Future<bool> checkSession() async {
    String? userToken = await _authLocalDataSource.getUserToken();

    if (userToken == null) {
      return false;
    } else {
      return _authRemoteDataSource.checkSession(userToken);
    }
  }
}
