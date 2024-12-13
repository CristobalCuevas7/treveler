import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/interest_point_repository.dart';

class GetAllInterestPointsUseCase {
  final InterestPointRepository _interestPointRepository;

  GetAllInterestPointsUseCase(this._interestPointRepository);

  Future<Result<List<InterestPoint>>> execute() async {
    try {
      return _interestPointRepository.getAllInterestPoints();
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
