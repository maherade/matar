// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:mattar/component/component.dart';
// import 'package:mattar/component/constants.dart';
//
// import '../../dio helper/dio_helper.dart';
// import '../../network/local/shared_pref.dart';
// import 'consumable_store.dart';
//
// final bool _kAutoConsume = Platform.isIOS || true;
//
// const String _kConsumableId = 'Remove Ads';
// const String _kUpgradeId = 'Remove Ads';
// const String _kSilverSubscriptionId = 'Remove Ads';
// const String _kGoldSubscriptionId = 'Remove Ads';
// const List<String> _kProductIds = [
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
//   _kGoldSubscriptionId,
// ];
//
// class adsScreen extends StatefulWidget {
//   @override
//   State<adsScreen> createState() => adsScreenState();
// }
//
// class adsScreenState extends State<adsScreen> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription =
//         purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (Object error) {
//       // handle error here.
//     });
//     initStoreInfo();
//     super.initState();
//   }
//
//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }
//
//     final ProductDetailsResponse productDetailResponse =
//         await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error!.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = <PurchaseDetails>[];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = <String>[];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       iosPlatformAddition.setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> stack = <Widget>[];
//     if (_queryProductError == null) {
//       stack.add(
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _buildConnectionCheckTile(),
//             _buildProductList(),
//             _buildConsumableBox(),
//             _buildRestoreButton(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError!),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//          Stack(
//           children: const <Widget>[
//             Opacity(
//               opacity: 0.3,
//               child: ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return MaterialApp(
//       home: Scaffold(
//         body: CacheHelper.getData(key: "login") == null
//             ? Container(
//           margin: const EdgeInsets.all(10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "يجب عليك تسجيل الدخول اولا",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline1
//                           ?.copyWith(color: Colors.grey, fontSize: 20),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     defaultButton(
//                         onPressed: () =>
//                             Navigator.of(context).pushNamed("login"),
//                         textButton: "تسجيل الدخول",
//                         backgroundColor: secondColor,
//                         radius: 12)
//                   ],
//                 ),
//               )
//             : CacheHelper.getData(key: "subscibtion") != null
//                 ? Center(
//                     child: Container(
//                       child: const Text(
//                         "انت مشترك بالفعل",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Stack(
//                     children: stack,
//                   ),
//       ),
//     );
//   }
//
//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return const Card(child: ListTile(title: Text('Trying to connect...')));
//     }
//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.check : Icons.block,
//           color: _isAvailable
//               ? Colors.green
//               : ThemeData.light().colorScheme.error),
//       title:
//           Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
//     );
//     final List<Widget> children = <Widget>[storeHeader];
//
//     if (!_isAvailable) {
//       children.addAll(<Widget>[
//         ListTile(
//           title: Text('Not connected',
//               style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           subtitle: const Text(
//               'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
//         ),
//       ]);
//     }
//     return Card(child: Column(children: children));
//   }
//
//   Card _buildProductList() {
//     if (_loading) {
//       return const Card(
//           child: ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('جاري التحميل...')));
//     }
//     if (!_isAvailable) {
//       return const Card();
//     }
//     Column productHeader =
//          Column(mainAxisAlignment: MainAxisAlignment.center, children: const []);
//     final List<Column> productList = <Column>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(Column(
//         children: [
//           Text('[${_notFoundIds.join(", ")}] not found',
//               style: TextStyle(color: ThemeData.light().colorScheme.error)),
//           const Text(
//               'This app needs special configuration to run. Please see example/README.md for instructions.')
//         ],
//       ));
//     }
//
//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verify the purchase data.
//     final Map<String, PurchaseDetails> purchases =
//         Map<String, PurchaseDetails>.fromEntries(
//             _purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         _inAppPurchase.completePurchase(purchase);
//       }
//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));
//     productList.addAll(_products.map(
//       (ProductDetails productDetails) {
//         final PurchaseDetails? previousPurchase = purchases[productDetails.id];
//         return Column(
//           children: [
//             previousPurchase != null
//                 ? IconButton(
//                     onPressed: () => confirmPriceChange(context),
//                     icon: const Icon(Icons.upgrade),
//                   )
//                 : Column(
//                     children: [
//                       Container(
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20),
//                           child: Image.asset(
//                             "images/4727116.png",
//                             height: 250,
//                           )),
//                       Container(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 20),
//                         child:  Column(
//                           children: const [
//                             Text(
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromRGBO(66, 105, 129, 1)),
//                                 'عند الاشتراك سوف يتم الغاء الاعلانات'),
//                             Text(
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromRGBO(66, 105, 129, 1)),
//                                 ' لمدة سنة مقابل 14.99 دولار'),
//                           ],
//                         ),
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor:
//                               const Color.fromRGBO(66, 105, 129, 1),
//                           // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
//                           // ignore: deprecated_member_use
//                           primary: Colors.white,
//                         ),
//                         onPressed: () {
//                           late PurchaseParam purchaseParam;
//
//                           if (Platform.isAndroid) {
//                             // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                             // verify the latest status of you your subscription by using server side receipt validation
//                             // and update the UI accordingly. The subscription purchase status shown
//                             // inside the app may not be accurate.
//                             final GooglePlayPurchaseDetails? oldSubscription =
//                                 _getOldSubscription(productDetails, purchases);
//
//                             purchaseParam = GooglePlayPurchaseParam(
//                                 productDetails: productDetails,
//                                 changeSubscriptionParam:
//                                     (oldSubscription != null)
//                                         ? ChangeSubscriptionParam(
//                                             oldPurchaseDetails: oldSubscription,
//                                             prorationMode: ProrationMode
//                                                 .immediateWithTimeProration,
//                                           )
//                                         : null);
//                           } else {
//                             purchaseParam = PurchaseParam(
//                               productDetails: productDetails,
//                             );
//                           }
//
//                           if (productDetails.id == _kConsumableId) {
//                             _inAppPurchase
//                                 .buyConsumable(
//                                     purchaseParam: purchaseParam,
//                                     autoConsume: _kAutoConsume)
//                                 .then((value) {});
//                           } else {
//                             _inAppPurchase.buyNonConsumable(
//                                 purchaseParam: purchaseParam);
//                           }
//                         },
//                         child: const Text(
//                           "اشتراك",
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       )
//                     ],
//                   ),
//           ],
//         );
//       },
//     ));
//
//     return Card(
//         margin: const EdgeInsets.all(15),
//         child: Center(
//           child: Column(children: <Widget>[productHeader] + productList),
//         ));
//   }
//
//   Card _buildConsumableBox() {
//     if (_loading) {
//       return const Card(
//           child: ListTile(
//               leading: CircularProgressIndicator(),
//               title: Text('Fetching consumables...')));
//     }
//     if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
//       return const Card();
//     }
//     const ListTile consumableHeader =
//         ListTile(title: Text('Purchased consumables'));
//     final List<Widget> tokens = _consumables.map((String id) {
//       return GridTile(
//         child: IconButton(
//           icon: const Icon(
//             Icons.stars,
//             size: 42.0,
//             color: Colors.orange,
//           ),
//           splashColor: Colors.yellowAccent,
//           onPressed: () => consume(id),
//         ),
//       );
//     }).toList();
//     return Card(
//         child: Column(children: <Widget>[
//       consumableHeader,
//       const Divider(),
//       GridView.count(
//         crossAxisCount: 5,
//         shrinkWrap: true,
//         padding: const EdgeInsets.all(16.0),
//         children: tokens,
//       )
//     ]));
//   }
//
//   Widget _buildRestoreButton() {
//     if (_loading) {
//       return Container();
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               // TODO(darrenaustin): Migrate to new API once it lands in stable: https://github.com/flutter/flutter/issues/105724
//               // ignore: deprecated_member_use
//               primary: Colors.white,
//             ),
//             onPressed: () => _inAppPurchase.restorePurchases(),
//             child: const Text('Restore purchases'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }
//
//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }
//
//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       final List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }
//
//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     return Future<bool>.value(true);
//   }
//
//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }
//
//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await InAppPurchase.instance.completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }
//
//   Future<void> confirmPriceChange(BuildContext context) async {
//     if (Platform.isAndroid) {
//       final InAppPurchaseAndroidPlatformAddition androidAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
//       final BillingResultWrapper priceChangeConfirmationResult =
//           await androidAddition.launchPriceChangeConfirmationFlow(
//         sku: 'purchaseId',
//       );
//       if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('Price change accepted'),
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//             priceChangeConfirmationResult.debugMessage ??
//                 'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//           ),
//         ));
//       }
//     }
//     if (Platform.isIOS) {
//       final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
//           _inAppPurchase
//               .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     }
//   }
//
//   GooglePlayPurchaseDetails? _getOldSubscription(
//       ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//     // This is just to demonstrate a subscription upgrade or downgrade.
//     // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//     // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//     // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//     // Please remember to replace the logic of finding the old subscription Id as per your app.
//     // The old subscription is only required on Android since Apple handles this internally
//     // by using the subscription group feature in iTunesConnect.
//     GooglePlayPurchaseDetails? oldSubscription;
//     if (productDetails.id == _kSilverSubscriptionId &&
//         purchases[_kGoldSubscriptionId] != null) {
//       oldSubscription =
//           purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
//     } else if (productDetails.id == _kGoldSubscriptionId &&
//         purchases[_kSilverSubscriptionId] != null) {
//       oldSubscription =
//           purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
//     }
//     return oldSubscription;
//   }
// }
//
// /// Example implementation of the
// /// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
// ///
// /// The payment queue delegate can be implementated to provide information
// /// needed to complete transactions.
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
