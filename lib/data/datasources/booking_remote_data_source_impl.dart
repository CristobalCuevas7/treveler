import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:treveler/data/util/api_response_parse.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/booking_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/discount_code.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final String _baseUrl;
  final AuthLocalDataSource _authLocalDataSource;
  final String _language;

  BookingRemoteDataSourceImpl(this._baseUrl, this._authLocalDataSource, this._language);

  @override
  Future<ApiResult<List<Booking>>> getAllBooking() async {
    final token = await _authLocalDataSource.getUserToken();
    final response = await http.get(Uri.parse("$_baseUrl/api/bookings"),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept-Language': _language});

    return processResponseList(response, Booking.fromJson);
  }

  @override
  Future<ApiResult<void>> activateBooking(Booking booking) async {
    final token = await _authLocalDataSource.getUserToken();
    final response = await http.post(Uri.parse('$_baseUrl/api/bookings/activate'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept-Language': _language},
        body: jsonEncode({'bookingId': booking.id}));

    return processResponse<void>(response);
  }

  @override
  Future<ApiResult<Booking>> addBooking(String bookingReference) async {
    final token = await _authLocalDataSource.getUserToken();
    final response = await http.post(Uri.parse('$_baseUrl/api/bookings/add'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept-Language': _language},
        body: jsonEncode({'bookingReference': bookingReference}));

    return processResponse<Booking>(response, (json) => Booking.fromJson(json));
  }

  @override
  Future<ApiResult<Booking>> buyBooking(
      String purchaseId, String platform, int transactionDate, int numberOfDays, DiscountCode? discountCode) async {
    final token = await _authLocalDataSource.getUserToken();
    final bodyMap = {
      'purchaseId': purchaseId,
      'platform': platform,
      'transactionDate': transactionDate,
      'numberOfDays': numberOfDays,
    };

    if (discountCode != null) {
      bodyMap['discountCode'] = discountCode.toJson();
    }

    final response = await http.post(Uri.parse('$_baseUrl/api/bookings/buy'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept-Language': _language
        },
        body: jsonEncode(bodyMap));

    return processResponse<Booking>(response, (json) => Booking.fromJson(json));
  }

}
