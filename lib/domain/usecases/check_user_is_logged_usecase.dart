import 'package:treveler/domain/repositories/auth_repository.dart';

class CheckUserIsLoggedUseCase {
  final AuthRepository _authRepository;

  CheckUserIsLoggedUseCase(
    this._authRepository,
  );

  Future<bool> execute() async {
    return (await _authRepository.getUserToken())?.isNotEmpty ?? false;
  }
}
