import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';

class SendCodeUseCase {
  final AuthRepository _authRepository;

  SendCodeUseCase(this._authRepository);

  Future<Result<void>> execute(String email) async {
    try {
      Result<void> result = await _authRepository.sendCode(email);
      return result.fold(onSuccess: (_) async {
        return const Success(null);
      }, onFailure: (message, errorType) {
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      return Failure(
        message: 'We can not send the code now. Try again later.',
        errorType: error.runtimeType,
      );
    }
  }
}
