import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/guide_repository.dart';

class GetAllGuidesUseCase {
  final GuideRepository _guideRepository;

  GetAllGuidesUseCase(this._guideRepository);

  Future<Result<List<Guide>>> execute() async {
    try {
      Result<List<Guide>> result = await _guideRepository.getAllGuides();

      return result.fold(
        onSuccess: (List<Guide> guides) {
          for (var guide in guides) {
            guide.points.sort((a, b) => a.position.compareTo(b.position));
          }
          return Success(guides);
        },
        onFailure: (String message, dynamic errorType) {
          return Failure(message: message, errorType: errorType);
        },
      );

      return result;
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
