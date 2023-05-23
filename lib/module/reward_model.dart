// import 'dart:developer';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:mattar/models/ads/ads_helper.dart';
//
// class AdRewarded {
//   static RewardedAd? rewardedAd;
//   static bool _isAdReady = false;
//   static bool adShowed = false;
//
//   static Future<void> loadAd() async {
//     adShowed = false;
//     RewardedAd.load(
//         adUnitId: AdsHelper.rewarderAds(),
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (ad) {
//             rewardedAd = ad;
//             _isAdReady = true;
//           },
//           onAdFailedToLoad: (error) {
//             log(
//                 "------------------Failed to load rewarded ad, Error: ${error.message}");
//           },
//         ));
//   }
//
//   static Future<void> showAd() async{
//     if (_isAdReady) {
//        rewardedAd?.show(onUserEarnedReward: (ad, rewardItem) {
//         log('---------------------reward item type = ${rewardItem.type}');
//         log('---------------------reward item amount = ${rewardItem.amount}');
//         adShowed = true;
//       });
//     }
//
//     rewardedAd?.fullScreenContentCallback =
//         FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
//           log('Ad Dismissed');
//           ad.dispose();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           ad.dispose();
//
//         },
//         );
//   }
//
// void _setFullScreenContentCallback() {
//   if (rewardedAd == null) return;
//   rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//     //when ad  shows fullscreen
//     onAdShowedFullScreenContent: (RewardedAd ad) =>
//         print("$ad onAdShowedFullScreenContent"),
//     //when ad dismissed by user
//     onAdDismissedFullScreenContent: (RewardedAd ad) {
//       print("$ad onAdDismissedFullScreenContent");
//
//       //dispose the dismissed ad
//       ad.dispose();
//     },
//     //when ad fails to show
//     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//       print("$ad  onAdFailedToShowFullScreenContent: $error ");
//       //dispose the failed ad
//       ad.dispose();
//     },
//
//     //when impression is detected
//     onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
//   );
// }
//
// void _showRewardedAd() {
//   //this method take a on user earned reward call back
//   rewardedAd!.show(
//       //user earned a reward
//       onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
//     //reward user for watching your ad
//     num amount = rewardItem.amount;
//     print("You earned: $amount");
//   });
// }
// }
