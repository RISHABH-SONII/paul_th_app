import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';

class Paymentcontroller extends GetxController {
  var isPuchased = true.obs;
  var purchases = Rxn<PurchaseDetails>();
  var _subscription = Rxn<StreamSubscription<List<PurchaseDetails>>>();

  final InAppPurchaseHandler _inAppPurchaseHandler = InAppPurchaseHandler();

  @override
  void onInit() async {
    super.onInit();

    // Initialize in-app purchases
    await _inAppPurchaseHandler.initialize();
    _inAppPurchaseHandler.listenToPurchase();
  }

  // In-App Purchase Methods
  Future<void> purchaseProduct(String productId) async {
    final product =
        _inAppPurchaseHandler.products.firstWhere((p) => p.id == productId);
    if (product != null) {
      await _inAppPurchaseHandler.purchaseProduct(product);
    } else {
      print("Product not found: $productId");
    }
  }

  Future<void> restorePurchases() async {
    await _inAppPurchaseHandler.restorePurchases();
  }

  void enablePremiumFeature() {
    // Logic to unlock premium feature
    print("Premium feature unlocked!");
    // Update app state or UI as needed
  }

  void enableSubscription() {
    // Logic to enable subscription
    print("Subscription enabled!");
    // Update app state or UI as needed
  }
}

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
    const Set<String> _kProductIds = {'seeprivate', 'com.example.subscription'};
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
        .listen((List<PurchaseDetails> purchaseDetailsList) async {
      for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
        switch (purchaseDetails.status) {
          case PurchaseStatus.purchased:
            print("Purchase successful: ${purchaseDetails.productID}");
            handlePurchase(purchaseDetails);
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
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void handlePurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.productID == 'seeprivate') {
      enablePremiumFeature();
    } else if (purchaseDetails.productID == 'com.example.subscription') {
      enableSubscription();
    }
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
