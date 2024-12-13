import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treveler/domain/datasources/interest_point_local_data_source.dart';
import 'package:treveler/domain/entities/interest_point.dart';

class InterestPointLocalDataSourceImpl implements InterestPointLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const String _interestPointKey = 'interest_point_key';

  InterestPointLocalDataSourceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<List<InterestPoint>> getAllInterestPoint() async {
    final String? interestPointListData = await _secureStorage.read(key: _interestPointKey);

    if (interestPointListData != null) {
      final List<dynamic> decodedData = jsonDecode(interestPointListData);
      final List<InterestPoint> interestPointList = decodedData.map((data) => InterestPoint.fromJson(data)).toList();
      return interestPointList;
    } else {
      return [];
    }
  }

  @override
  Future<void> saveInterestPoint(InterestPoint interestPoint) async {
    final List<InterestPoint> existingInterestPoint = await getAllInterestPoint();
    existingInterestPoint.add(interestPoint);

    final String guideData = jsonEncode(existingInterestPoint);
    await _secureStorage.write(key: _interestPointKey, value: guideData);
  }

  @override
  Future<void> cleanInterestPoints() async {
    await _secureStorage.delete(key: _interestPointKey);
  }
}
