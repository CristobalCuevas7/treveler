import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';

class VerifyCodeUseCase {
  final AuthRepository _authRepository;

  VerifyCodeUseCase(this._authRepository);

  Future<Result<void>> execute(String email, String code) async {
    try {
      Result<void> result = await _authRepository.verifyCode(email, code);
      return result.fold(onSuccess: (_) async {
        return const Success(null);
      }, onFailure: (message, errorType) {
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      return Failure(
        message: 'We can not verify the code now. Try again later.',
        errorType: error.runtimeType,
      );
    }
  }
}
