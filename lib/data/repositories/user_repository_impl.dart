import 'package:treveler/domain/datasources/user_local_data_source.dart';
import 'package:treveler/domain/datasources/user_remote_data_source.dart';
import 'package:treveler/domain/entities/api_result.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/user_repository.dart';
import 'package:treveler/util/log.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _userLocalDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepositoryImpl(this._userLocalDataSource, this._userRemoteDataSource);

  @override
  Future<void> deletePremiumUntil() async {
    _userLocalDataSource.deletePremiumUntil();
  }

  @override
  Future<void> deleteEmail() async {
    _userLocalDataSource.deleteEmail();
  }

  @override
  Future<void> deleteUserId() async {
    _userLocalDataSource.deleteUserId();
  }

  @override
  Future<String?> getEmail() async {
    return _userLocalDataSource.getEmail();
  }

  @override
  Future<DateTime?> getPremiumUntil() async {
    return _userLocalDataSource.getPremiumUntil();
  }

  @override
  Future<int?> getUserId() async {
    return _userLocalDataSource.getUserId();
  }

  @override
  Future<void> storeEmail(String email) async {
    _userLocalDataSource.storeEmail(email);
  }

  @override
  Future<void> storeUserId(int userId) async {
    _userLocalDataSource.storeUserId(userId);
  }

  @override
  Future<void> storePremiumUntil(DateTime? dateTime) async {
    Log.show("Saving premium until: ${dateTime?.toIso8601String()}");
    _userLocalDataSource.storePremiumUntil(dateTime);
    Log.show("Saved");
  }

  @override
  Future<Result<void>> selectLanguage(String language) async {
    return await _userRemoteDataSource.selectLanguage(language).toResult();
  }

  @override
  Future<Result<DateTime?>> fetchPremium() async{
    return await _userRemoteDataSource.checkPremium().toResult();
  }
}