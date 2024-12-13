import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';

class ChangePasswordWithCodeUseCase {
  final AuthRepository _authRepository;

  ChangePasswordWithCodeUseCase(this._authRepository);

  Future<Result<void>> execute(String email, String code, String password) async {
    try {
      Result<void> result = await _authRepository.changePasswordWithCode(email, code, password);
      return result.fold(onSuccess: (_) async {

        return const Success(null);
      }, onFailure: (message, errorType) {
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      return Failure(
        message: 'We can not change the password now. Try again later.',
        errorType: error.runtimeType,
      );
    }
  }
}
