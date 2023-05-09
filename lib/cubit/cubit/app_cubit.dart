import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mattar/component/component.dart';
import 'package:mattar/dio%20helper/dio_helper.dart';
import 'package:mattar/models/map/maps.dart';
import 'package:mattar/models/mattar%20video%20and%20image/video.dart';
import 'package:mattar/models/weather%20expected.dart';
import 'package:mattar/module/LoginModel.dart';
import 'package:mattar/module/copon_model.dart';
import 'package:mattar/module/private_ads_model.dart';
import 'package:mattar/module/profile_model.dart';
import 'package:mattar/module/weather%20model.dart';
import 'package:mattar/network/local/shared_pref.dart';

import '../../component/constants.dart';
import '../../models/ads/ads_helper.dart';
import '../../module/notification model.dart';
import '../../module/user shared model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<ApppState> {
  AppCubit() : super(AppInitial());

  static AppCubit caller(context) => BlocProvider.of(context);
  bool isPassword = true;
  Icon icon = const Icon(Icons.visibility);
  bool isSHC = false;

  void SHC(bool value) {
    isSHC = value;
    print(value);
    emit(ShowCommentDone());
  }

  PageController? scrollController;

  void goToFirstPage() {
    scrollController?.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    print("object");
    emit(GoToFirstPageState());
  }

  int currentIndex = CacheHelper.getData(key: "index") ?? 0;
  List<Widget> bottomNavScreen = [
    WeatehrExpected(),
    Maps(),
    const Videos(),
  ];

  void changeBottomNavIndex(int index) {
    CacheHelper.saveData(key: "index", value: index);
    currentIndex = CacheHelper.getData(key: "index");
    emit(BottomNavState());
  }

  void changeLoginVisibility() {
    isPassword = !isPassword;
    icon = isPassword
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    emit(ChangeLoginPasswordVisibility());
  }

  final ImagePicker _picker = ImagePicker();
  XFile? packedImage;

  Future picImage({
    required ImageSource fromWhere,
    required String name,
    required String email,
    required String location,
    required String phone,
    required String password,
  }) async {
    var image;
    image = await _picker.pickImage(
      source: fromWhere,
    );
    if (image != null) {
      packedImage = XFile(image.path);
    } else {
      emit(GetProfileSuccessful());
    }

    await updateUser(
      name: name,
      email: email,
      location: location,
      phone: phone,
      password: password,
    );
  }

  updateUser({
    required String name,
    required String email,
    required String location,
    required String phone,
    required String password,
  }) async {
    String? fileName = packedImage?.path.split('/').last;
    FormData formData;
    emit(GetProfileLoading());
    if (packedImage == null) {
      if (password == "") {
        ShopDioHelper.postData(
                url: "update-profile",
                data: {
                  "name": name,
                  "email": email,
                  "country": location,
                  'phone': phone
                },
                token: CacheHelper.getData(key: "token"))
            .then((value) async {
          await getProfileData();
        }).catchError((e) {
          emit(UpdateUserError());
        });
      } else {
        formData = FormData.fromMap({
          "name": name,
          "email": email,
          "country": location,
          'phone': phone,
          "password": password
        });
        ShopDioHelper.postData(
                url: "update-profile",
                data: formData,
                token: CacheHelper.getData(key: "token"))
            .then((value) async {
          await getProfileData();
        }).catchError((e) {
          emit(UpdateUserError());
        });
      }
    } else {
      if (password == "") {
        ShopDioHelper.postData(
                url: "update-profile",
                data: FormData.fromMap({
                  "pic": await MultipartFile.fromFile(packedImage!.path,
                      filename: fileName),
                  "name": name,
                  "email": email,
                  "country": location,
                  'phone': phone,
                }),
                token: CacheHelper.getData(key: "token"))
            .then((value) async {
          await getProfileData();
        }).catchError((e) {
          emit(UpdateUserError());
        });
      } else {
        ShopDioHelper.postData(
                url: "update-profile",
                data: FormData.fromMap({
                  "pic": await MultipartFile.fromFile(packedImage!.path,
                      filename: fileName),
                  "name": name,
                  "email": email,
                  "country": location,
                  'phone': phone,
                  "password": password
                }),
                token: CacheHelper.getData(key: "token"))
            .then((value) async {
          await getProfileData();
        }).catchError((e) {
          emit(UpdateUserError());
        });
      }
    }
  }

  LoginModel? login;

  void userLogin({
    required String? email,
    required String? password,
  }) {
    emit(ShopLoginLoadingState());
    ShopDioHelper.postData(
      url: "auth/login",
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      login = LoginModel.fromJson(value.data);
      // print(
      //     "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      // print(login?.subscription);
      // if (login?.subscription == []) {
      //   CacheHelper.saveData(key: "subscibtion", value: true);
      //   print(CacheHelper.getData(key: "subscibtion"));
      // }
      // if (CacheHelper.getData(key: "subscibtion") != true) {
      //   if (login?.coupon != "null") {
      //     CacheHelper.saveData(key: "subscibtion", value: true);
      //   }
      // } else {
      //   print(CacheHelper.getData(key: "subscibtion"));
      // }
      emit(ShopLoginSuccessState());
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  void userSignUp(
      {required String? email,
      required String? password,
      required String? name,
      required String? country}) {
    emit(SignUpLoadingState());
    ShopDioHelper.postData(
      url: "auth/signup",
      data: {
        'email': email,
        'password': password,
        'name': name,
        'country': country
      },
      language: 'ar',
    ).then((value) {
      if (value.statusCode == 200) {
        print("signUp Successfully");
      } else if (value.statusCode == 404) {
        print("email is signuped");
      }
      emit(SignUpSuccessState());
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
    });
  }

  List<NotificationModel> notificationData = [];

  Future getNotificationData() async {
    emit(GetDataLoadingState());
    notificationData.clear();
    await ShopDioHelper.getData(
      url: NOTI,
    ).then((value) {
      // ignore: avoid_print
      value.data
          .forEach((e) => notificationData.add(NotificationModel.fromJson(e)));
      emit(GetDataSuccessState());
    }).catchError((error) {
      emit(GetDataErrorState());
    });
  }

  List<WeatherModel> post = [];
  List<WeatherModel> posts = [];
  List<WeatherModel> selectedPosts = [];
  List postComments = [];
  List ind = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49];
  bool? a = false;

  void getWeatherPostes() {
    a = false;
    emit(GetWeatherPostsLoading());
    ShopDioHelper.getData(url: "outlooks/").then((value) {
      value.data.forEach((element) => post.add(WeatherModel.fromJson(element)));

      for (int i = 0; i < post.length; i++) {
        if (ind.contains(i)) {
          posts.add(post[i]);
          posts.add(post[i]);
        } else {
          posts.add(post[i]);
        }
      }
      post.forEach((element) {
        postComments.add(element.comments);
      });
      a = true;
      emit(GetWeatherPostsSuccess());
    }).catchError((e) {
      emit(GetWeatherPostsError());
    });
  }

  void getSelectedWeatherPosts({
    required int countryId
   }) {

    a = false;
    emit(GetWeatherPostsLoading());
    ShopDioHelper.getData(url: "v2/outlooks/${countryId}").then((value) {


      value.data.forEach((element) => selectedPosts.add(WeatherModel.fromJson(element)));

      print('------------------------------------------------');
      print(value.data[0]['title']);
      print(selectedPosts[0].title);
      print('------------------------------------------------');
      // for (int i = 0; i < post.length; i++) {
      //   if (ind.contains(i)) {
      //     posts.add(post[i]);
      //     posts.add(post[i]);
      //   } else {
      //     posts.add(post[i]);
      //   }
      // }
      // post.forEach((element) {
      //   postComments.add(element.comments);
      // });
      a = true;
      emit(GetWeatherPostsSuccess());
    }).catchError((e) {
      emit(GetWeatherPostsError());
    });
  }


  int pageViewInd = 0;

  IncreasePageiewInd() {
    pageViewInd++;
    emit(CahngePageViewInd());
  }

  DecreasePageiewInd() {
    pageViewInd--;
    emit(CahngePageViewInd());
  }

  void addComment(int index, String comment, int outLook, int userid) {
    posts[index].comments.add(Comments(
        id: 235,
        outlookId: outLook,
        userId: userid,
        comment: comment,
        reply: "",
        date: DateTime.now().toString(),
        user: UserC(
            id: profile!.id,
            name: profile!.name,
            email: profile!.email,
            country: profile!.country,
            phone: profile!.phone,
            facebookToken: profile!.facebookToken,
            googleToken: profile!.googleToken,
            token: profile!.token,
            role: profile!.role,
            pic: profile!.pic,
            date: profile!.date,
            coupon: profile!.coupon,
            ban: profile!.ban)));
    emit(AddComment());
  }

  List<UserSharedModel> userShared = [];

  void getUserShared() {
    emit(UserSharedLoading());
    ShopDioHelper.postData(
            url: "shared-posts", token: CacheHelper.getData(key: "token"))
        .then((value) async {
      print(value.data[2]["date"]);
      value.data.forEach((e) => userShared.add(UserSharedModel.fromJson(e)));

      emit(UserSharedSuccess());
    }).catchError((onError) {
      emit(UserSharedError());
    });
  }

  void sendComment({required int outlookId, required String comment}) {
    emit(CommentLoadingState());
    ShopDioHelper.postData(
        token: CacheHelper.getData(key: "token"),
        url: "send-comment",
        data: {"outlook_id": outlookId, "comment": comment}).then((value) {
      print("comment send");
      emit(CommentSuccessfulState());
    }).catchError((e) {
      emit(CommentErrorState());
    });
  }

  void sendLike({required int outlookId}) {
    emit(LikeLoadingState());
    ShopDioHelper.postData(
        token: CacheHelper.getData(key: "token"),
        url: "submit-like",
        data: {"outlook_id": outlookId}).then((value) {
      emit(LikeSuccessfulState());
    }).catchError((e) {
      emit(LikeErrorState());
    });
  }

  void sendShare({required int outlookId}) {
    emit(ShareLoadingState());
    ShopDioHelper.postData(
        token: CacheHelper.getData(key: "token"),
        url: "outlook/share",
        data: {"outlook_id": outlookId}).then((value) {
      print("comment send");
      emit(ShareSuccessfulState());
    }).catchError((e) {
      emit(ShareErrorState());
    });
  }

  ProfileModel? profile;

  getProfileData() {
    emit(GetProfileLoading());
    ShopDioHelper.getData(
            url: "profile", token: CacheHelper.getData(key: "token"))
        .then((value) {
      profile = ProfileModel.fromJson(value.data);
      print(login?.subscription);
      if (profile?.sub == true) {
        CacheHelper.saveData(key: "subscibtion", value: true);
      } else {
        CacheHelper.removeData(key: "subscibtion");
      }

      emit(GetProfileSuccessful());
    }).catchError((e) {
      emit(GetProfileError());
    });
  }

  CoponModel? coponModel;

  sendCopon({required String copon}) {
    // print(CacheHelper.getData(key: "coponDays"));
    emit(PostCoponLoading());

    ShopDioHelper.postData(
        url: "apply-coupon",
        token: CacheHelper.getData(key: "token"),
        data: {"coupon": copon, "device_id": profile?.id}).then((value) {
      if (value.extra.isNotEmpty) {
        coponModel = CoponModel.fromJson(value.data);
        CacheHelper.saveData(
            key: "copond",
            value:
                "${DateTime.now().add(Duration(days: int.parse(coponModel!.days)))}");
      } else {
        CacheHelper.saveData(key: "show ads", value: true);
      }
      print(CacheHelper.getData(key: "copond"));
      emit(PostCoponSuccessful());
    }).catchError((e) {
      emit(PostCoponError());
    });
  }

  //
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Future<String> signInWithGoogle() async {
  //   emit(ShopLoginLoadingState());
  //
  //   GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount!.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //   final UserCredential authResult =
  //       await _auth.signInWithCredential(credential);
  //   final User? user = authResult.user;
  //   if (user != null) {
  //     assert(user.email != null);
  //     assert(user.displayName != null);
  //     assert(user.photoURL != null);
  //     var name = user.displayName;
  //     var email = user.email;
  //     var imageUrl = user.photoURL;
  //     assert(!user.isAnonymous);
  //     assert(await user.getIdToken() != null);
  //     final User? currentUser = _auth.currentUser;
  //     assert(user.uid == currentUser!.uid);
  //     print('signInWithGoogle succeeded: $user');
  //     ShopDioHelper.postData(
  //       url: "auth/social/google",
  //       data: {
  //         "name": user.displayName,
  //         "email": user.email,
  //         "google_token": user.uid
  //       },
  //     ).then((value) {
  //       login = LoginModel.fromJson(value.data);
  //       CacheHelper.saveData(key: "google", value: true);
  //       emit(ShopLoginSuccessState());
  //     }).catchError((e) {
  //       emit(ShopLoginErrorState(e));
  //     });
  //     return '$user';
  //   }
  //
  //   return "";
  // }

  // googleSignOut() {
  //   _googleSignIn.signOut().then((value) {
  //     emit(GoogleSignOut());
  //   });
  // }

  void checkCopon() {
    if (CacheHelper.getData(key: "copond") != null) {
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse(CacheHelper.getData(key: "copond"));
      bool valDate = endDate.isBefore(now);
      if (valDate) {
        CacheHelper.removeData(key: "copond");
      } else {
        print("nooooooooooooooooooooooooooooooooooooooooo");
      }
    }
  }

  sendproblem({required String content}) {
    emit(PostCoponLoading());
    ShopDioHelper.postData(
        url: "send-ticket",
        data: {"email": login?.email, "content": content}).then((value) {
      emit(PostCoponSuccessful());
    }).catchError((e) {
      emit(PostCoponError());
    });
  }

  List<AdsModel> adsModel = [];

  getPrivateAds() {
    emit(GetAdsLoading());
    ShopDioHelper.getData(url: "ads").then((value) {
      value.data.forEach((e) {
        adsModel.add(AdsModel.fromJson(e));
      });
      emit(GetAdsSuccessful());
    }).catchError((e) {
      emit(GetAdsError());
    });
  }

  late AdmobReward admobInitSt;

  initAds() {
    admobInitSt = AdmobReward(
      adUnitId: AdsHelper.rewarderAds(),
    );
    admobInitSt.load();
    emit(InitAd());
  }

  late AdmobInterstitial admobInterstitial;

  initAdsIntter() {
    admobInterstitial = AdmobInterstitial(
      adUnitId: AdsHelper.getinitAd(),
    );
    admobInitSt.load();
    emit(InitAd());
  }

  late AdmobBannerSize admobBannerSize;

  initAdBannar() {
    admobBannerSize = AdmobBannerSize.ADAPTIVE_BANNER(width: 500);
  }

  // late NativeAd ad;
  // bool isLoaded = false;
  // void loadNativeAd() {
  //   ad = NativeAd(
  //       request: const AdRequest(),

  //       ///This is a test adUnitId make sure to change it
  //       adUnitId: 'ca-app-pub-1287908343391910/5547213562',
  //       factoryId: 'listTile',
  //       listener: NativeAdListener(onAdLoaded: (ad) {
  //         isLoaded = true;
  //         emit(InitAd());
  //       }, onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         print('failed to load the ad ${error.message}, ${error.code}');
  //       }));

  //   ad.load();
  // }

  void changeMap() {
    CacheHelper.saveData(key: "show ads", value: true);
    emit(ChangeMapState());
  }

  increaseAdsView(int adsId) {
    ShopDioHelper.postData(url: "increase-views", data: {"ad_id": adsId})
        .then((value) {
      emit(PostCoponSuccessful());
    }).catchError((e) {
      emit(PostCoponError());
    });
  }

  increaseAdsClick(int adsId) {
    ShopDioHelper.postData(url: "increase-clicks", data: {"ad_id": adsId})
        .then((value) {
      print("incressed");
      emit(CommentSuccessfulState());
    }).catchError((e) {
      emit(CommentErrorState());
    });
  }

  void sendReplay(
      {required int outlookId,
      required int commentId,
      required String reply,
      required BuildContext context}) {
    emit(CommentLoadingState());
    print("send");
    ShopDioHelper.postData(
        token: CacheHelper.getData(key: "token"),
        url: "send-reply",
        data: {
          "comment_id": commentId,
          "outlook_id": outlookId,
          "reply": reply
        }).then((value) {
      print("sended");

      emit(CommentSuccessfulState());
    }).catchError((e) {
      emit(CommentErrorState());
    });
  }

// String country = "";
// void changeCountryValue(String value) {
//   country = value;
//   emit(CahngeCountryState());
// }

// String getCountry() {
//   emit(CahngeCountryState());
//   return country;
// }
// StreamSubscription? _subscription;
// bool connectedState = true;
// void connected() {
//   connectedState = true;
//   emit(ConnectedState());
// }

// void notConnected() {
//   connectedState = false;
//   emit(NotConnectedState());
// }

// void checkConnection() {
//   _subscription = Connectivity()
//       .onConnectivityChanged
//       .listen((ConnectivityResult result) {
//     if (result == ConnectivityResult.wifi ||
//         result == ConnectivityResult.mobile) {
//       emit(ConnectedState());
//     } else {
//       emit(NotConnectedState());
//     }
//   });
// }

// @override
// Future<void> close() {
//   _subscription?.cancel();
//   return super.close();
// }

  // Delete User
  void deleteUser({
    required String? token,
  }) {
    emit(DeleteUserLoadingState());
    ShopDioHelper.deleteData(url: '/api/request-delete-account', token: token)
        .then((value) {
      if (value.statusCode == 200) {
        print("User Deleted Successfully");
      } else if (value.statusCode == 404) {
        print("email is not found");
      }
      emit(DeleteUserSuccessState());
    }).catchError((error) {
      emit(DeleteUserErrorState(error.toString()));
    });
  }

  void loginWithGoogle({
    required String? name,
    required String? email,
    required String? googleToken,
  }) {
    ShopDioHelper.postData(
      url: "auth/social/google",
      data: {
        'name': name,
        'email': email,
        'google_token': googleToken,
      },
    ).then((value) {
      // print(value.data);

      print(value.statusCode);
      login = LoginModel.fromJson(value.data);

      print('----------------------------------------');
      print(login!.name);
      print(login!.email);
      print('----------------------------------------');

      emit(LoginWithGoogleSuccessState());
    }).catchError((error) {
      print('Error');

      print("Error in google login in postman is ${error.toString()}");

      emit(LoginWithGoogleErrorState());
    });
  }


  Future<void> googleFunction(context)async{

    final googleSignIn = GoogleSignIn();

    try{
      GoogleSignInAccount ?googleSignInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =await googleSignInAccount!.authentication;

      final credential = GoogleAuthProvider.credential(

        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,

      );

      await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        loginWithGoogle(
            name: googleSignInAccount.displayName,
            email: googleSignInAccount.email,
            googleToken: "${googleSignInAccount.id}"
        );

      });

      print("Name in google function ${googleSignInAccount.displayName}");
      print("Name in accessToken ${credential.accessToken}");
      print("Name in idToken ${credential.idToken}");
      print("Name in id ${googleSignInAccount.id}");



      // AppStrings.uId=googleSignInAccount.id;
      // CashHelper.saveDataSharedPreference(key: 'googleEmail', value: googleSignInAccount.email);
      // CashHelper.saveDataSharedPreference(key: 'displayName', value: googleSignInAccount.displayName);
      // CashHelper.saveDataSharedPreference(key: 'imageUrl', value: googleSignInAccount.photoUrl);
      // CashHelper.saveDataSharedPreference(key: 'googleId', value: googleSignInAccount.id);

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context)=>const EnterPhoneScreen())
      // );

       emit(LoginWithGoogleSuccessState());

    } on FirebaseAuthException catch(e){

      var content ='';

      switch(e.code){
        case'account-exists-with-different-credential':
          content='this account exists with a different sign in provider';
          break;

        case'invalid-credential':
          content='unKnown error has occurred';
          break;

        case'operation-not-allowed':
          content='this operation is not allowed';
          break;

        case'user-disabled':
          content='the user you tried to log into is disabled';
          break;

        case'user-not-found':
          content='the user you tried to log into was not found';
          break;
      }

      customToast(title: content, color: Colors.red);
      emit(LoginWithGoogleErrorState());

    } catch(e){

      customToast(title: 'An unknown error occurred ,try again', color: Colors.red);
      emit(LoginWithGoogleErrorState());

    }

  }


}
