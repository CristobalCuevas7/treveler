import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:treveler/domain/entities/discount_code.dart';
import 'package:treveler/domain/entities/payment_option.dart';
import 'package:treveler/domain/entities/purchasable_product.dart';
import 'package:treveler/util/iap_connection.dart';
import 'package:treveler/util/log.dart';

class DashPurchases extends ChangeNotifier {
  final List<PaymentOption> _paymentOptions;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  HashMap<String, PurchasableProduct> productsHashMap = HashMap();
  final iapConnection = IAPConnection.instance;
  final Function(PurchaseDetails)? onSuccess;
  final Function(List<PaymentOption>)? onLoadFinish;
  final VoidCallback? onFail;
  final oneDay = "1_day";
  final ids = <String>{"1_day", "2_days", "3_days", "1_day_d10", "2_days_d10", "3_days_d10"};

  DashPurchases(this._paymentOptions, {this.onSuccess, this.onFail, this.onLoadFinish}) {
    final purchaseUpdated = iapConnection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
    loadPurchases();
    // loadMockPurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  int checkDiscount(double oneDayPrice, double toComparePrice, int numberOfDays) {
    Log.show("Calculating discount for $numberOfDays with a price of $toComparePrice, when one day is $oneDayPrice");
    double withoutDiscount = oneDayPrice * numberOfDays;
    double discount = ((toComparePrice - withoutDiscount) / withoutDiscount) * 100;

    Log.show("Discount is: ${discount.abs().toInt()}");

    return discount.abs().toInt();
  }

  Future<void> loadPurchases() async {
    final available = await iapConnection.isAvailable();
    if (!available) {
      notifyListeners();
      return;
    }
    final response = await iapConnection.queryProductDetails(ids);
    for (var element in response.notFoundIDs) {
      debugPrint('Purchase $element not found');
    }
    productsHashMap = response.productDetails
        .map((e) => PurchasableProduct(e))
        .fold(HashMap<String, PurchasableProduct>(), (map, product) {
      map[product.id] = product;
      return map;
    });

    final priceDayOne = productsHashMap[oneDay]!.productDetails.rawPrice;
    final List<PaymentOption> fullPaymentOptions = [];

    Log.show("Loading purchases");

    for (var paymentOption in _paymentOptions) {
      if (productsHashMap.containsKey(paymentOption.paymentId)) {
        Log.show("Calculating for ${paymentOption.paymentId}");
        fullPaymentOptions.add(PaymentOption(
            id: paymentOption.id,
            numberOfDays: paymentOption.numberOfDays,
            paymentId: paymentOption.paymentId,
            price: productsHashMap[paymentOption.paymentId]!.price,
            rawPrice: productsHashMap[paymentOption.paymentId]!.productDetails.rawPrice,
            currency: productsHashMap[paymentOption.paymentId]!.productDetails.currencySymbol,
            discount: checkDiscount(priceDayOne, productsHashMap[paymentOption.paymentId]!.productDetails.rawPrice,
                paymentOption.numberOfDays)));
      }
    }

    onLoadFinish?.call(fullPaymentOptions);
    notifyListeners();
  }

  double priceFor1Day(List<PurchasableProduct> products) {
    for (var element in products) {
      if (element.id == oneDay) return element.productDetails.rawPrice;
    }
    return 0;
  }

  Future<void> buy(String productId, DiscountCode? discountCode) async {
    final productIdWithDiscount = discountCode != null ? "${productId}_d${discountCode.discount}" : productId;
    final product = productsHashMap[productIdWithDiscount]!;
    final purchaseParam = PurchaseParam(productDetails: product.productDetails);

    await iapConnection.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    Log.show("onPurchaseUpdate with ${purchaseDetailsList.length} elements");
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
    notifyListeners();
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    Log.show("handlePurchase");
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      Log.show("-----------");
      Log.show("Purchased productID - ${purchaseDetails.productID}");
      Log.show("Purchased status - ${purchaseDetails.status.name}");
      Log.show("Purchased pending - ${purchaseDetails.pendingCompletePurchase}");
      Log.show("Purchased purchaseID - ${purchaseDetails.purchaseID}");
      Log.show("Purchased transactionDate - ${purchaseDetails.transactionDate}");
      Log.show("Purchased localVerificationData - ${purchaseDetails.verificationData.localVerificationData}");
      Log.show("Purchased serverVerificationData - ${purchaseDetails.verificationData.serverVerificationData}");
      Log.show("Purchased source - ${purchaseDetails.verificationData.source}");
      Log.show("-----------");
      onSuccess?.call(purchaseDetails);
    }

    if (purchaseDetails.pendingCompletePurchase) {
      Log.show("NO COMPLETED");
      await iapConnection.completePurchase(purchaseDetails);
      Log.show("Complete purchase called for ${purchaseDetails.productID}");
    }
  }

  void _updateStreamOnDone() {
    Log.show("Purchase Done");
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    Log.show("Error: ${error.toString()}");
    onFail?.call();
  }

  //Testing propose
  Future<void> loadMockPurchases() async {
    final List<PaymentOption> fullPaymentOptions = [];

    fullPaymentOptions.add(PaymentOption(id: 1, numberOfDays: 1, paymentId: "1", price: "\$14.99", discount: 0, currency: "\$", rawPrice: 14.99));
    fullPaymentOptions.add(PaymentOption(id: 2, numberOfDays: 2, paymentId: "2", price: "\$26.98", discount: 10, currency: "\$", rawPrice: 26.98));
    fullPaymentOptions.add(PaymentOption(id: 3, numberOfDays: 3, paymentId: "3", price: "\$38.22", discount: 15, currency: "\$", rawPrice: 38.22));

    onLoadFinish?.call(fullPaymentOptions);
    notifyListeners();
  }
}
