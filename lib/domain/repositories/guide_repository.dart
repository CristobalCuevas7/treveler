import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/result.dart';

abstract class GuideRepository {
  Future<Result<List<Guide>>> getAllGuides();
}
