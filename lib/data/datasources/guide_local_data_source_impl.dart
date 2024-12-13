import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treveler/domain/datasources/guide_local_data_source.dart';
import 'package:treveler/domain/entities/guide.dart';

class GuideLocalDataSourceImpl implements GuideLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  static const String _guideKey = 'guide_key';

  GuideLocalDataSourceImpl() : _secureStorage = const FlutterSecureStorage();

  @override
  Future<List<Guide>> getAllGuides() async {
    final String? guideData = await _secureStorage.read(key: _guideKey);

    if (guideData != null) {
      final List<dynamic> decodedData = jsonDecode(guideData);
      final List<Guide> guides = decodedData.map((data) => Guide.fromJson(data)).toList();
      return guides;
    } else {
      return [];
    }
  }

  @override
  Future<void> saveGuide(Guide guide) async {
    final List<Guide> existingGuides = await getAllGuides();
    existingGuides.add(guide);

    final String guideData = jsonEncode(existingGuides);
    await _secureStorage.write(key: _guideKey, value: guideData);
  }

  @override
  Future<void> cleanGuides() async {
    await _secureStorage.delete(key: _guideKey);
  }
}
