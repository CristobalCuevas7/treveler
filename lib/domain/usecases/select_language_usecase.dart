import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';

class SelectLanguageUseCase {
  final UserRepository _userRepository;

  SelectLanguageUseCase(this._userRepository);

  Future<Result<void>> execute(String language) async {
    try {
      Result<void> result = await _userRepository.selectLanguage(language);
      return result.fold(onSuccess: (_) async {
        return const Success(null);
      }, onFailure: (message, errorType) {
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      return Failure(
        message: 'We can not change the language now. Try again later.',
        errorType: error.runtimeType,
      );
    }
  }
}
