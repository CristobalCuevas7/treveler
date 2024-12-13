import 'package:treveler/domain/entities/category.dart';
import 'package:treveler/domain/entities/location.dart';

class InterestPoint {
  final int id;
  final String name;
  final String image;
  final String? price;
  final String description;
  final String? instagram;
  final String? website;
  final bool requiresPayment;
  double? distance;
  final Location location;
  final Category category;
  final bool isLocked;

  InterestPoint({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.instagram,
    required this.website,
    required this.requiresPayment,
    required this.distance,
    required this.location,
    required this.category,
    required this.isLocked,
  });

  factory InterestPoint.fromJson(Map<String, dynamic> json) {
    return InterestPoint(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String?,
      description: json['description'] as String,
      instagram: json['instagram'] as String?,
      website: json['website'] as String?,
      requiresPayment: json['requiresPayment'] as bool,
      distance: json['distance'] as double?,
      isLocked: json['isLocked'] as bool,
      location: Location.fromJson(json['location']),
      category: Category.fromJson(json['category']),
    );
  }
}