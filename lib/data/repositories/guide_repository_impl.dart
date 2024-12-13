import 'package:treveler/domain/datasources/guide_local_data_source.dart';
import 'package:treveler/domain/datasources/guide_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart' as ApiResult;
import 'package:treveler/domain/entities/guide.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/guide_repository.dart';
import 'package:treveler/util/log.dart';

class GuideRepositoryImpl implements GuideRepository {
  final GuideLocalDataSource _guideLocalDataSource;
  final GuideRemoteDataSource _guideRemoteDataSource;

  GuideRepositoryImpl(this._guideLocalDataSource, this._guideRemoteDataSource);

  @override
  Future<Result<List<Guide>>> getAllGuides() async {
    Result<List<Guide>> result = await _guideRemoteDataSource.getAllGuides().toResult();

    return result.fold(onSuccess: (guideList) {
      // _guideLocalDataSource.cleanGuides();
      //
      // for (var guide in guideList) {
      //   _guideLocalDataSource.saveGuide(guide);
      // }
    Log.show("Success in get guides");
      return result;
    }, onFailure: (message, error) async {
      Log.show("Fail in get guides $message");
      List<Guide> localGuides = await _guideLocalDataSource.getAllGuides();
      return Success(localGuides);
    });
  }
}
