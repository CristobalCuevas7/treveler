import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:treveler/data/util/api_response_parse.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/user_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/my_user.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _baseUrl;
  final AuthLocalDataSource _authLocalDataSource;
  final String _language;

  UserRemoteDataSourceImpl(this._baseUrl, this._authLocalDataSource, this._language);

  @override
  Future<ApiResult<void>> selectLanguage(String language) async {
    final token = await _authLocalDataSource.getUserToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/api/user/language"),
      headers: headers,
      body: jsonEncode({'language': language}),
    );

    return processResponse<MyUser>(response, (json) => MyUser.fromJson(json));
  }

  @override
  Future<ApiResult<DateTime?>> checkPremium() async {
    final token = await _authLocalDataSource.getUserToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    };

    final response = await http.get(Uri.parse("$_baseUrl/api/user/checkPremium"), headers: headers);

    return processResponse<DateTime?>(
        response, (json) => json['validUntil'] != null ? DateTime.parse(json['validUntil']) : null);
  }
}
