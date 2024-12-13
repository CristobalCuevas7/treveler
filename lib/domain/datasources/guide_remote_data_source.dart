import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/guide.dart';

abstract class GuideRemoteDataSource {
  Future<ApiResult<List<Guide>>> getAllGuides();
}
