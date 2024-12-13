class PaymentOption {
  final int id;
  final int numberOfDays;
  final String paymentId;
  final double? rawPrice;
  final String? currency;
  String? price;
  int? discount;

  PaymentOption({required this.id, required this.numberOfDays, required this.paymentId, this.price, this.discount, this.rawPrice, this.currency});

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      id: json['id'],
      numberOfDays: json['numberOfDays'],
      paymentId: json['paymentId']
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'numberOfDays': numberOfDays, 'paymentId': paymentId};
  }
}
