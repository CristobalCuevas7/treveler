import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/payment_repository.dart';

class VerifyDiscountCodeUseCase {
  final PaymentRepository _paymentRepository;

  VerifyDiscountCodeUseCase(this._paymentRepository);

  Future<Result<DiscountCode>> execute(String discountCode) async {
    return await _paymentRepository.verifyDiscountCode(discountCode);
  }
}
