import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';

class GetEmailUseCase {
  final UserRepository _userRepository;

  GetEmailUseCase(this._userRepository);

  Future<Result<String>> execute() async {
    String? result = await _userRepository.getEmail();

    if (result != null) {
      return Success(result);
    } else {
      return const Failure(message: "Unexpected error");
    }
  }
}
