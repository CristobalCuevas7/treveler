import 'package:treveler/domain/entities/interest_point.dart';

abstract class InterestPointLocalDataSource {
  Future<List<InterestPoint>> getAllInterestPoint();

  Future<void> saveInterestPoint(InterestPoint interestPoint);

  Future<void> cleanInterestPoints();
}
