import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/interest_point.dart';

abstract class InterestPointRemoteDataSource {
  Future<ApiResult<List<InterestPoint>>> getAllInterestPoint();
}
