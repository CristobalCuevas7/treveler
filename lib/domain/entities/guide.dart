import 'package:treveler/domain/entities/guide_point.dart';

class Guide {
  final int id;
  final String image;
  final String name;
  final String description;
  final double totalDistance;
  final List<GuidePoint> points;

  Guide({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.totalDistance,
    required this.points,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonPoints = json['points'];
    final List<GuidePoint> points = jsonPoints.map((point) => GuidePoint.fromJson(point)).toList();

    return Guide(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      totalDistance: json['totalDistance'] as double,
      points: points,
    );
  }
}