import 'package:treveler/domain/repositories/auth_repository.dart';
import 'package:treveler/domain/entities/my_user.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final CleanUserDataUseCase _cleanUserDataUseCase;

  RegisterUseCase(this._authRepository, this._userRepository, this._cleanUserDataUseCase);

  Future<Result<MyUser>> execute(String email, String password) async {
    try {
      Result<MyUser> userResult = await _authRepository.registerUser(email, password);
      return userResult.fold(onSuccess: (user) async {

        await _authRepository.storeUserToken(user.token);
        await _userRepository.storeUserId(user.id);
        await _userRepository.storeEmail(user.email);

        return Success(user);
      }, onFailure: (message, errorType) {
        _cleanUserDataUseCase.execute();
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      _cleanUserDataUseCase.execute();
      return Failure(
        message: 'An error occurred while register.',
        errorType: error.runtimeType,
      );
    }
  }
}