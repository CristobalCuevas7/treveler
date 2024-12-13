import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/auth_repository.dart';
import 'package:treveler/domain/usecases/clean_user_data_usecase.dart';

class DeleteAccountUseCase {
  final AuthRepository _authRepository;
  final CleanUserDataUseCase _cleanUserDataUseCase;

  DeleteAccountUseCase(this._authRepository, this._cleanUserDataUseCase);

  Future<Result<void>> execute() async {
    try {
      final result = await _authRepository.removeAccount();
      return result.fold(onSuccess: (_) async {
        await _cleanUserDataUseCase.execute();
        return const Success(null);
      }, onFailure: (message, error) {
        return result;
      });
    } catch (error) {
      return Failure(
        message: 'An error occurred while try to delete account.',
        errorType: error.runtimeType,
      );
    }
  }
}
