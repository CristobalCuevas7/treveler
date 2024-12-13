import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:treveler/data/util/api_response_parse.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/auth_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/my_user.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String _baseUrl;
  final AuthLocalDataSource _authLocalDataSource;
  final String _language;

  AuthRemoteDataSourceImpl(this._baseUrl, this._authLocalDataSource, this._language);

  @override
  Future<ApiResult<MyUser>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/api/auth/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': _language,
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return processResponse<MyUser>(response, (json) => MyUser.fromJson(json));
  }

  @override
  Future<ApiResult<MyUser>> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': _language,
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    return processResponse<MyUser>(response, (json) => MyUser.fromJson(json));
  }

  @override
  Future<ApiResult<void>> removeAccount() async {
    final token = await _authLocalDataSource.getUserToken();
    final response = await http.post(Uri.parse('$_baseUrl/api/auth/remove'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    });

    return processResponse<void>(response);
  }

  @override
  Future<ApiResult<void>> sendCode(String email) async {
    final response = await http.post(Uri.parse('$_baseUrl/api/auth/forgotPassword'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': _language,
        },
        body: jsonEncode({'email': email}));

    return processResponse<void>(response);
  }

  @override
  Future<ApiResult<void>> verifyCode(String email, String code) async {
    final response = await http.post(Uri.parse('$_baseUrl/api/auth/verifyCode'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': _language,
        },
        body: jsonEncode({'email': email, 'code': code}));

    return processResponse<void>(response);
  }

  @override
  Future<ApiResult<void>> changePasswordWithCode(String email, String code, String password) async {
    final response = await http.post(Uri.parse('$_baseUrl/api/auth/changePasswordWithCode'),
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': _language,
        },
        body: jsonEncode({'email': email, 'code': code, 'newPassword': password}));

    return processResponse<void>(response);
  }

  @override
  Future<bool> checkSession(String token) async {
    final token = await _authLocalDataSource.getUserToken();
    final response = await http.get(Uri.parse('$_baseUrl/api/auth/checkSession'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      return false;
    } else {
      throw Exception("Failed trying to check session");
    }
  }
}
