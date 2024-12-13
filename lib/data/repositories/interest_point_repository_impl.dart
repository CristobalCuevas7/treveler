import 'package:treveler/domain/datasources/interest_point_local_data_source.dart';
import 'package:treveler/domain/datasources/interest_point_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart' as ApiResult;
import 'package:treveler/domain/entities/interest_point.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/interest_point_repository.dart';
import 'package:treveler/util/log.dart';

class InterestPointRepositoryImpl implements InterestPointRepository {
  final InterestPointLocalDataSource _interestPointLocalDataSource;
  final InterestPointRemoteDataSource _interestPointRemoteDataSource;

  InterestPointRepositoryImpl(this._interestPointLocalDataSource, this._interestPointRemoteDataSource);

  @override
  Future<Result<List<InterestPoint>>> getAllInterestPoints() async {
    Result<List<InterestPoint>> result = await _interestPointRemoteDataSource.getAllInterestPoint().toResult();

    return result.fold(onSuccess: (guideList) {
      // _guideLocalDataSource.cleanGuides();
      //
      // for (var guide in guideList) {
      //   _guideLocalDataSource.saveGuide(guide);
      // }
      Log.show("Success in get all interest points");
      return result;
    }, onFailure: (message, error) async {
      Log.show("Fail in get all interest points $message");
      List<InterestPoint> localInterestPoints = await _interestPointLocalDataSource.getAllInterestPoint();
      return Success(localInterestPoints);
    });
  }
}
