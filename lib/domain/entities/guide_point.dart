import 'package:treveler/domain/entities/location.dart';

class GuidePoint {
  final int id;
  final String name;
  final String image;
  final String audio;
  final String description;
  final int position;
  final bool isLocked;
  final Location location;

  GuidePoint({
    required this.id,
    required this.name,
    required this.image,
    required this.audio,
    required this.description,
    required this.position,
    required this.isLocked,
    required this.location,
  });

  factory GuidePoint.fromJson(Map<String, dynamic> json) {
    return GuidePoint(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      audio: json['audio'] as String,
      description: json['description'] as String,
      position: json['position'] as int,
      isLocked: json['isLocked'] as bool,
      location: Location.fromJson(json['location']),
    );
  }
}