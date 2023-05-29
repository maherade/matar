import 'dart:io';

class AdsHelper {
  static bool _testMood = false;

  static String getBunnerAd() {
    // if (_testMood) {
    //   return AdmobBanner.testAdUnitId;
    // }
    if (Platform.isAndroid) {
      return "ca-app-pub-2342851934476929/8822850492";
    } else if (Platform.isIOS) {
      return "-----------------------------------";
    } else {
      return "UnSuported platForm";
    }
  }

  static String getinitAd() {
    // if (_testMood) {
    //   return AdmobInterstitial.testAdUnitId;
    // }
    if (Platform.isAndroid) {
      return "-----------------------------------";
    } else if (Platform.isIOS) {
      return "-----------------------------------";
    } else {
      return "UnSuported platForm";
    }
  }

  static String rewarderAds() {
    // if (_testMood) {
    //   return AdmobReward.testAdUnitId;
    // }
    if (Platform.isAndroid) {
      return "ca-app-pub-2342851934476929/7882032206";
    } else if (Platform.isIOS) {
      return "ca-app-pub-2342851934476929/4360130728";
    } else {
      return "UnSuported platForm";
    }
  }
}
