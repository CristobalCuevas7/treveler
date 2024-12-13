import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/payment_repository.dart';

class GetPaymentOptionsUseCase {
  final PaymentRepository _paymentRepository;

  GetPaymentOptionsUseCase(this._paymentRepository);

  Future<Result<List<PaymentOption>>> execute() async {
    try {
      final result = await _paymentRepository.getPaymentOptions();

      return result.fold(
          onSuccess: (paymentOptions) {
            paymentOptions.sort((a, b) => a.numberOfDays.compareTo(b.numberOfDays));
            return Success(paymentOptions);
          },
          onFailure: (message, error) => result);
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
