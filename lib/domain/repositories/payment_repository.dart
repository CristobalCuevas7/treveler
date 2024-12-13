import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/domain/entities/result.dart';

abstract class PaymentRepository {
  Future<Result<List<PaymentOption>>> getPaymentOptions();

  Future<Result<DiscountCode>> verifyDiscountCode(String discountCode);
}
