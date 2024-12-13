class DiscountCode {
  final int id;
  final int discount;
  final bool reusable;
  final String code;
  final DateTime created;
  final DateTime? expire;
  final bool used;

  DiscountCode({
    required this.id,
    required this.discount,
    required this.reusable,
    required this.code,
    required this.created,
    required this.expire,
    required this.used,
  });

  factory DiscountCode.fromJson(Map<String, dynamic> json) {
    return DiscountCode(
      id: json['id'] as int,
      discount: json['discount'] as int,
      reusable: json['reusable'] as bool,
      code: json['code'] as String,
      created: DateTime.parse(json['created']),
      expire: json['expire'] != null ? DateTime.parse(json['expire']) : null,
      used: json['used'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'reusable': reusable,
      'code': code,
      'created': created.toIso8601String(),
      'expire': expire?.toIso8601String(),
      'used': used,
    };
  }
}
