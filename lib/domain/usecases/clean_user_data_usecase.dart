import 'package:treveler/domain/repositories/auth_repository.dart';
import 'package:treveler/domain/repositories/user_repository.dart';

class CleanUserDataUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  CleanUserDataUseCase(this._authRepository, this._userRepository);

  Future<void> execute() async {
    await _authRepository.deleteUserToken();
    await _userRepository.deleteUserId();
    await _userRepository.deleteEmail();
    await _userRepository.deletePremiumUntil();
  }
}
