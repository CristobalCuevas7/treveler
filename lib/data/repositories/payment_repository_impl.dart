import 'package:treveler/domain/datasources/payment_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _paymentRemoteDataSource;

  PaymentRepositoryImpl(this._paymentRemoteDataSource);

  @override
  Future<Result<List<PaymentOption>>> getPaymentOptions() async {
    return await _paymentRemoteDataSource.getPaymentOptions().toResult();
  }

  @override
  Future<Result<DiscountCode>> verifyDiscountCode(String discountCode) async {
    return await _paymentRemoteDataSource.verifyDiscountCode(discountCode).toResult();
  }
}
