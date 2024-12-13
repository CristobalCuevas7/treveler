import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:treveler/domain/entities/api_error.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/util/log.dart';

Future<ApiResult<T>> processResponse<T>(http.Response response,
    [T Function(Map<String, dynamic>)? parseSuccess]) async {
  Log.show("Request: ${response.request}");
  Log.show("Header: ${response.request?.headers}");
  Log.show("Status Code: ${response.statusCode}");
  Log.show("Body: ${response.body}");

  final responseBody = response.body.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : "";

  if (response.statusCode == 200) {
    return parseSuccess != null ? Success(parseSuccess(responseBody)) : const Success(Null) as ApiResult<T>;
  } else {
    return _parseError(responseBody);
  }
}

Future<ApiResult<List<T>>> processResponseList<T>(
    http.Response response, T Function(Map<String, dynamic>) parseSuccess) async {
  Log.show("Request: ${response.request}");
  Log.show("Header: ${response.request?.headers}");
  Log.show("Status Code: ${response.statusCode}");
  Log.show("Body: ${response.body}");

  final responseBody = response.body.isNotEmpty ? jsonDecode(utf8.decode(response.bodyBytes)) : "";

  if (response.statusCode == 200 && responseBody is List) {
    return Success(responseBody.cast<Map<String, dynamic>>().map(parseSuccess).toList());
  } else {
    return _parseError(responseBody);
  }
}

Future<ApiResult<T>> _parseError<T>(dynamic responseBody) async {
  try {
    return Failure<T>(
        error: ApiError(
            error: responseBody['error'],
            dev: responseBody['message']['dev'],
            message: responseBody['message']['user']));
  } catch (error) {
    return Failure<T>(
        error: ApiError(
            error: 'Unexpected error',
            dev: 'Unexpected error',
            message: 'Unexpected error, error parser fail'));
  }
}
