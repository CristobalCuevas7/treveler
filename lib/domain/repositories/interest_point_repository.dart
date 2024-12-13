import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/entities/result.dart';

abstract class InterestPointRepository {
  Future<Result<List<InterestPoint>>> getAllInterestPoints();
}
