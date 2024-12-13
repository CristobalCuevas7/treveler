import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';

abstract class PaymentRemoteDataSource {
  Future<ApiResult<List<PaymentOption>>> getPaymentOptions();

  Future<ApiResult<DiscountCode>> verifyDiscountCode(String discountCode);
}
