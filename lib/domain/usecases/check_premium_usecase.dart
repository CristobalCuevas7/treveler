import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';
import 'package:treveler/util/log.dart';

class CheckPremiumUseCase {
  final UserRepository _userRepository;

  CheckPremiumUseCase(this._userRepository);

  Future<Result<bool>> execute() async {
    try {
      DateTime? premiumUntil = await _userRepository.getPremiumUntil();
      Log.show("Premium until: ${premiumUntil?.toIso8601String()}");
      if (premiumUntil != null && premiumUntil.isAfter(DateTime.now())) {
        return const Success(true);
      } else {
        return const Success(false);
      }
    } catch (error) {
      return Failure(
        message: 'An error occurred while check session.',
        errorType: error.runtimeType,
      );
    }
  }
}
