import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';

class CheckSessionUseCase {
  final AuthRepository _authRepository;
  final CleanUserDataUseCase _cleanUserDataUseCase;

  CheckSessionUseCase(this._authRepository, this._cleanUserDataUseCase);

  Future<Result<bool>> execute() async {
    try {
      bool isValid = await _authRepository.checkSession();
      return Success(isValid);
    } catch (error) {
      await _cleanUserDataUseCase.execute();
      return Failure(
        message: 'An error occurred while check session.',
        errorType: error.runtimeType,
      );
    }
  }
}
