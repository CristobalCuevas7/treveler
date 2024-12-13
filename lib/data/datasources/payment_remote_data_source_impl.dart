import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:treveler/data/util/api_response_parse.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/payment_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final String _baseUrl;
  final AuthLocalDataSource _authLocalDataSource;
  final String _language;

  PaymentRemoteDataSourceImpl(this._baseUrl, this._authLocalDataSource, this._language);

  @override
  Future<ApiResult<List<PaymentOption>>> getPaymentOptions() async {
    final token = await _authLocalDataSource.getUserToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    };

    final response = await http.get(Uri.parse("$_baseUrl/api/payment/options"), headers: headers);

    return processResponseList(response, PaymentOption.fromJson);
  }

  @override
  Future<ApiResult<DiscountCode>> verifyDiscountCode(String discountCode) async {
    final token = await _authLocalDataSource.getUserToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/api/payment/verify"),
      headers: headers,
      body: jsonEncode({'code': discountCode}),
    );

    return processResponse<DiscountCode>(response, (json) => DiscountCode.fromJson(json));
  }
}
