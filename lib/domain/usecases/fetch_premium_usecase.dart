import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';

class FetchPremiumUseCase {
  final UserRepository _userRepository;

  FetchPremiumUseCase(this._userRepository);

  Future<Result<bool>> execute() async {
    try {
      Result<DateTime?> result = await _userRepository.fetchPremium();
      return result.fold(onSuccess: (premiumUntil) async {
        if (premiumUntil != null && premiumUntil.isAfter(DateTime.now())) {
          await _userRepository.storePremiumUntil(premiumUntil);
          return const Success(true);
        } else {
          await _userRepository.deletePremiumUntil();
          return const Success(false);
        }
      }, onFailure: (message, errorType) async {
        await _userRepository.deletePremiumUntil();
        return Failure(message: message, errorType: errorType);
      });
    } catch (error) {
      await _userRepository.deletePremiumUntil();
      return Failure(
        message: 'An error occurred while check session.',
        errorType: error.runtimeType,
      );
    }
  }
}
