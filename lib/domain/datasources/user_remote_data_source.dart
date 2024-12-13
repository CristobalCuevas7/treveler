import 'package:treveler/domain/entities/api_result.dart';

abstract class UserRemoteDataSource {
  Future<ApiResult<void>> selectLanguage(String language);
  Future<ApiResult<DateTime?>> checkPremium();
}
