import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseHandler with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;

  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      return;
    }

    const Set<String> _kProductIds = {'seeprivate', ''};
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("Product IDs not found: ${response.notFoundIDs}");
    }
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void listenToPurchase() {
    _inAppPurchase.purchaseStream
        .listen((List<PurchaseDetails> purchaseDetailsList) {
      for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
        switch (purchaseDetails.status) {
          case PurchaseStatus.purchased:
            print("Purchase successful: ${purchaseDetails.productID}");
            break;
          case PurchaseStatus.restored:
            print("Purchase restored: ${purchaseDetails.productID}");
            handleRestoredPurchase(purchaseDetails);
            break;
          case PurchaseStatus.pending:
            print("Purchase pending: ${purchaseDetails.productID}");
            break;
          case PurchaseStatus.error:
            print("Purchase error: ${purchaseDetails.error}");
            break;
          case PurchaseStatus.canceled:
            print("Purchase canceled: ${purchaseDetails.productID}");
            break;
        }
      }
    });
  }

  void handleRestoredPurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.productID == 'seeprivate') {
      enablePremiumFeature();
    } else if (purchaseDetails.productID == 'com.example.subscription') {
      enableSubscription();
    }
  }

  void enablePremiumFeature() {
    // Logic to unlock premium feature
    print("Premium feature unlocked!");
  }

  void enableSubscription() {
    // Logic to enable subscription
    print("Subscription enabled!");
  }
}
