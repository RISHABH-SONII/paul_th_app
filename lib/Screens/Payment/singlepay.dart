import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/Screens/Payment/build_transection_json.dart';
import 'package:tharkyApp/Screens/Payment/paymentFormScreen/paymentFormScreen.dart';
import 'package:tharkyApp/Screens/components/privatepubliclytotal.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';

//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:tharkyApp/utils/common.dart';
import 'package:tharkyApp/utils/configs.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Tab.dart';

class SinglePayment extends StatefulWidget {
  final bool? isPaymentSuccess;
  final Map items;
  final User user;

  SinglePayment(this.user, this.isPaymentSuccess, this.items);

  @override
  _SinglePaymentState createState() => _SinglePaymentState();
}

class _SinglePaymentState extends State<SinglePayment> {
  bool isAvailable = true;
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  late ProductDetails selectedPlan;
  late ProductDetails selectedProduct;
  var response;
  bool _isLoading = true;
  InAppPurchase _iap = InAppPurchase.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initialize();
    // Show payment failure alert.
    if (widget.isPaymentSuccess != null && !widget.isPaymentSuccess!) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.error,
          title: "Failed".tr().toString(),
          desc: "Oops !! something went wrong. Try Again".tr().toString(),
          buttons: [
            DialogButton(
              child: Text(
                "Retry".tr().toString(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<String>> _fetchPackageIds() async {
    List<String> packageId = ["seeprivate"];

    // await FirebaseFirestore.instance
    //     .collection("Packages")
    //     .where('status', isEqualTo: true)
    //     .get()
    //     .then((value) {
    //   packageId.addAll(value.docs.map((e) => e['id']));
    // });

    return packageId;
  }

  void _initialize() async {
    isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      List<Future> futures = [
        _getProducts(await _fetchPackageIds()),
        //_getpastPurchases(false),
      ];
      await Future.wait(futures);

      /// removing all the pending puchases.
      if (Platform.isIOS) {
        var paymentWrapper = SKPaymentQueueWrapper();
        var transactions = await paymentWrapper.transactions();
        transactions.forEach((transaction) async {
          print(transaction.transactionState);
          await paymentWrapper
              .finishTransaction(transaction)
              .catchError((onError) {
            print('finishTransaction Error $onError');
          });
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Rks.context = context;
    _showCurrencyDialog(BuildContext context, String tokenQuantity,
        String amount, String currency) {
      String selectedCurrency = currency;
      String selectedPackageAmount = amount;
      final transaction = TransactionBuilder.buildTransaction(
        contextType: 'token',
        amount: selectedPackageAmount,
        selectedCurrency: selectedCurrency,
        currentUser: {
          'id': widget.user.id,
          'name': widget.user.name,
        },
        tokens: int.tryParse(tokenQuantity) ?? 0,
      );

      // Navigator.pop(context);

      print("Transaction Json : ${transaction}");

      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaymentFormScreen(
          transaction: transaction, // if you need this later
        ),
      ));
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          50.height,
          Container(
            margin: EdgeInsets.only(top: 20, right: 20),
            alignment: Alignment.topRight,
            child: IconButton(
              alignment: Alignment.topRight,
              color: Colors.black,
              icon: Icon(
                Icons.cancel,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Buy contents of".tr().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: black,
                        fontSize: 25,
                        fontWeight: FontWeight.normal),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      80,
                    ),
                    child: CachedNetworkImage(
                      height: 150,
                      width: 150,
                      fit: BoxFit.fill,
                      imageUrl: imageUrl(widget.user.imageUrl![0])!,
                      useOldImageOnUrlChange: true,
                      placeholder: (context, url) => loadingImage(),
                      errorWidget: (context, url, error) => errorImage(),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      widget.user.firstName! + " " + widget.user.lastName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showCurrencyDialog(context, "1", "1.0", "EUR");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Buy 1 token £1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      _showCurrencyDialog(context, "10", "10.0", "EUR");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Buy 10 token £10',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      _showCurrencyDialog(context, "20", "20.0", "EUR");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '20 token £20',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(
                  //     Icons.star,
                  //     color: Colors.amber,
                  //   ),
                  //   title: Text(
                  //     "Whole the folder.".tr().toString(),
                  //     style:
                  //         TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  //   ),
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(
                  //     Icons.star,
                  //     color: Colors.amber,
                  //   ),
                  //   title: Text(
                  //     "one time for ever",
                  //     style:
                  //         TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  //   ).tr(args: ["${widget.items['paid_radius'] ?? ''}"]),
                  // ),
                  _isLoading
                      ? Container(
                          height: MediaQuery.of(context).size.width * .8,
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryColor)),
                          ),
                        )
                      : products.length > 0
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Center(
                                  child: ListTile(
                                    title: Text(
                                      selectedProduct.title,
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      selectedProduct.description,
                                      textAlign: TextAlign.center,
                                    ),
                                    trailing: Text(
                                        "${products.indexOf(selectedProduct) + 1}/${products.length}"),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              height: MediaQuery.of(context).size.width * .4,
                              child: Center(
                                child: Text("No active product found!!"
                                    .tr()
                                    .toString()),
                              ),
                            )
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blackColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .2,
                    vertical: MediaQuery.of(context).size.height * .02,
                  ),
                ),
                child: Text(
                  "CONTINUE".tr().toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  _buyProduct(selectedProduct);
                },
              )),
          // SizedBox(
          //   height: 15,
          // ),
          Platform.isIOS
              ? InkWell(
                  child: Container(
                      color: blackColor,
                      height: MediaQuery.of(context).size.height * .055,
                      width: MediaQuery.of(context).size.width * .55,
                      child: Center(
                          child: Text(
                        "RESTORE PURCHASE".tr().toString(),
                        style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                            fontWeight: FontWeight.bold),
                      ))),
                  onTap: () async {
                    // var result = await _getpastPurchases();
                    // if (result.length == 0) {
                    //   showDialog(
                    //       context: context,
                    //       builder: (ctx) {
                    //         return AlertDialog(
                    //           content:
                    //               Text("No purchase found".tr().toString()),
                    //           title: Text("Past Purchases".tr().toString()),
                    //         );
                    //       });
                    // }
                  },
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Text(
                  "Privacy Policy".tr().toString(),
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () => launchUrl(Uri.parse(UPDATED_PRIVACY_POLICY_URL)),
              ),
              GestureDetector(
                child: Text(
                  "Terms & Conditions".tr().toString(),
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () => launchUrl(Uri.parse(UPDATED_PRIVACY_POLICY_URL)),
              ),
            ],
          ).paddingAll(8),
        ],
      )),
    );
  }

  Widget productList({
    required BuildContext context,
    required String intervalCount,
    required String interval,
    required Function onTap,
    required ProductDetails product,
    required String price,
  }) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      height: 100,
      //setting up dimention if product get selected
      width: selectedProduct !=
              product //setting up dimention if product get selected
          ? MediaQuery.of(context).size.width * .19
          : MediaQuery.of(context).size.width * .22,
      decoration: selectedProduct == product
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(width: 2, color: primaryColor))
          : null,
      duration: Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * .02),
          Text(intervalCount,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up color if product get selected
                      ? Colors.black
                      : primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Text(interval,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up color if product get selected
                      ? Colors.black
                      : primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          Text(price,
              style: TextStyle(
                  color: selectedProduct !=
                          product //setting up product if product get selected
                      ? Colors.black
                      : primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
        //      )),
      ),
    );
  }

  ///fetch products
  Future<void> _getProducts(List<String> _productIds) async {
    if (_productIds.length > 0) {
      Set<String> ids = Set.from(_productIds);
      print('====**$ids');
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      setState(() {
        products = response.productDetails;
      });

      //initial selected of products
      products.forEach((element) {});
      if (products.isNotEmpty) {
        selectedProduct = products[0];
      } else {
        // Handle the case where there are no products
        // Maybe show an error message or return early
        setState(() {
          _isLoading = false;
        });
        return;
      }
      // selectedProduct = (products.length > 0 ? products[0] : null)!;
    }
  }

  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere(
      (purchase) => purchase.productID == productId,
      //orElse: () => null
    );
  }

  Future<void> _verifyPuchase(
    String id,
  ) async {
    PurchaseDetails purchase = _hasPurchased(id);
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      myprintnet('===***${purchase.productID}');

      // if (Platform.isIOS) {
      await _iap.completePurchase(purchase);
      //}
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) {
          return Tabbar(
            purchase.productID,
            true,
          );
        }),
      );
    } else if (purchase.status == PurchaseStatus.error) {
      Navigator.pop(context);
    }
    return;
  }

  void _buyProduct(ProductDetails product) async {
    myprint(product);
    Rks.product = product;
    Rks.payingUser = widget.user;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    // _simulatePurchase(product);
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
  }

  String getInterval(ProductDetails product) {
    product as AppStoreProductDetails;
    SKSubscriptionPeriodUnit periodUnit =
        product.skProduct.subscriptionPeriod!.unit;
    if (SKSubscriptionPeriodUnit.month == periodUnit) {
      return "Month(s)";
    } else if (SKSubscriptionPeriodUnit.week == periodUnit) {
      return "Week(s)";
    } else {
      return "Year";
    }
  }

  String getIntervalAndroid(ProductDetails product) {
    product as GooglePlayProductDetails;
    String durCode = ""; //product.skuDetails.subscriptionPeriod.split("")[2];
    if (durCode == "M" || durCode == "m") {
      return "Month(s)";
    } else if (durCode == "Y" || durCode == "y") {
      return "Year";
    } else {
      return "Week(s)";
    }
  }
}
