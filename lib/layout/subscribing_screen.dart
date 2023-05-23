import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class SubscribingScreen extends StatefulWidget {
  static const String routeName = 'sub';

  const SubscribingScreen({super.key});

  @override
  State<SubscribingScreen> createState() => _SubscribingScreenState();
}

class _SubscribingScreenState extends State<SubscribingScreen> {
  String os = Platform.operatingSystem;
  final paymentItems = [
    const PaymentItem(
      label: 'للإشتراك',
      amount: '14.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشتراك'),
        backgroundColor: const Color.fromRGBO(66, 105, 129, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Platform.isAndroid
                  ? GooglePayButton(
                      width: double.infinity,
                      paymentConfigurationAsset: 'gpay.json',
                      paymentItems: paymentItems,
                      type: GooglePayButtonType.subscribe,
                      // margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ApplePayButton(
                      paymentConfigurationAsset: 'appay.json',
                      paymentItems: paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.subscribe,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: (data) {},
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

// var appleButton = ApplePayButton(
//   paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
//   paymentItems: const [
//     PaymentItem(
//       label: 'Item A',
//       amount: '0.01',
//       status: PaymentItemStatus.final_price,
//     ),
//     PaymentItem(
//       label: 'Item B',
//       amount: '0.01',
//       status: PaymentItemStatus.final_price,
//     ),
//     PaymentItem(
//       label: 'Total',
//       amount: '0.02',
//       status: PaymentItemStatus.final_price,
//     )
//   ],
//   style: ApplePayButtonStyle.black,
//   width: double.infinity,
//   height: 50,
//   type: ApplePayButtonType.buy,
//   margin: const EdgeInsets.only(top: 15.0),
//   onPaymentResult: (result) => debugPrint('Payment Result $result'),
//   loadingIndicator: const Center(
//     child: CircularProgressIndicator(),
//   ),
// );
// var googlePayButton = GooglePayButton(
//   paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
//   paymentItems: const [
//     PaymentItem(
//       label: 'Item A',
//       amount: '0.01',
//       status: PaymentItemStatus.final_price,
//     ),
//     PaymentItem(
//       label: 'Item B',
//       amount: '0.01',
//       status: PaymentItemStatus.final_price,
//     ),
//     PaymentItem(
//       label: 'Total',
//       amount: '0.02',
//       status: PaymentItemStatus.final_price,
//     )
//   ],
//   type: GooglePayButtonType.pay,
//   margin: const EdgeInsets.only(top: 15.0),
//   onPaymentResult: (result) => debugPrint('Payment Result $result'),
//   loadingIndicator: const Center(
//     child: CircularProgressIndicator(),
//   ),
// );
}
