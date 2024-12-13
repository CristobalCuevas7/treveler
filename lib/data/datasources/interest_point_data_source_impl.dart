import 'package:http/http.dart' as http;
import 'package:treveler/data/util/api_response_parse.dart';
import 'package:treveler/domain/datasources/auth_local_data_source.dart';
import 'package:treveler/domain/datasources/interest_point_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/interest_point.dart';

class InterestPointRemoteDataSourceImpl implements InterestPointRemoteDataSource {
  final String _baseUrl;
  final AuthLocalDataSource _authLocalDataSource;
  final String _language;

  InterestPointRemoteDataSourceImpl(this._baseUrl, this._authLocalDataSource, this._language);

  @override
  Future<ApiResult<List<InterestPoint>>> getAllInterestPoint() async {
    final token = await _authLocalDataSource.getUserToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept-Language': _language,
    };

    final response = await http.get(Uri.parse("$_baseUrl/api/interestpoint"), headers: headers);

    return processResponseList(response, InterestPoint.fromJson);
  }
}
