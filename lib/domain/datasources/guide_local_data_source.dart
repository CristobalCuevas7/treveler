import 'package:treveler/domain/entities/guide.dart';

abstract class GuideLocalDataSource {
  Future<List<Guide>> getAllGuides();

  Future<void> saveGuide(Guide guide);

  Future<void> cleanGuides();
}
