import 'package:intl/intl.dart';

class Booking {
  final int id;
  final String reference;
  final int numberOfDays;
  final DateTime? activated;
  final DateTime created;

  Booking({
    required this.id,
    required this.reference,
    required this.numberOfDays,
    this.activated,
    required this.created,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      reference: json['reference'] as String,
      numberOfDays: json['numberOfDays'] as int,
      activated: json['activated'] != null ? DateTime.parse(json['activated']) : null,
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'numberOfDays': numberOfDays,
      'activated': activated?.toIso8601String(),
      'created': created.toIso8601String(),
    };
  }

  String getFormattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }
}
