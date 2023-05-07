import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mattar/dio%20helper/dio_helper.dart';
import 'package:mattar/module/private_ads_model.dart';
import 'package:mattar/module/video%20model.dart';
import 'package:mattar/network/local/shared_pref.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  static VideoCubit caller(context) => BlocProvider.of(context);
  List<VideoModel> posts = [];
  List<VideoModel> post = [];
  List ind = [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49];

  void getVideoPostes() {
    emit(GetVideoLoadingState());
    ShopDioHelper.getData(url: "weatherShots").then((value) {
      print("nnnnn");
      value.data.forEach((element) => post.add(VideoModel.fromJson(element)));
      for (int i = 0; i < post.length; i++) {
        if (ind.contains(i)) {
          posts.add(post[i]);
          posts.add(post[i]);
        } else {
          posts.add(post[i]);
        }
      }
      emit(GetVideoSuccessState());
    }).catchError((e) {
      emit(GetVideoErrorState());
    });
  }

  void uploadFiles({
    required String dis,
    required String location,
    required String time,
  }) async {
    emit(uploadFileLoadingState());
    String fileName = packedImage!.path.split('/').last;
    FormData formData = FormData.fromMap({
      'user_id': 3,
      "photographer": dis,
      "location": location,
      "date": time,
      'media':
          await MultipartFile.fromFile(packedImage!.path, filename: fileName)
    });
    print("....upload");

    ShopDioHelper.postData(
            url: "send-pending-shot",
            data: formData,
            token: CacheHelper.getData(key: "token"))
        .then((value) {
      if (value.statusCode == 200) {
        print("data uploaded");
      }

      emit(uploadFileSuccessState());
    }).catchError((e) {
      print("error $e");
      emit(uploadFileErrorState());
    });
  }

  final ImagePicker _picker = ImagePicker();
  File? packedImage;
  var extention;
  bool? isImage;

  Future fetchImage(
      {required String type, required ImageSource fromWhere}) async {
    var image;
    print("loadsing iamge");
    if (type == "image") {
      image = await _picker.pickImage(
        source: fromWhere,
      );
    } else {
      image = await _picker.pickVideo(source: fromWhere);
    }
    if (image != null) {
      packedImage = File(image.path);
      extention = p.extension(packedImage.toString());
      print(extention);
      extention == ".jpg'" ? isImage = true : isImage = false;
    }
    emit(VideoPickedSuccessful());
  }

  late VideoPlayerController v;

  showImage() {
    if (isImage == null) {
      return const Text("يجب اختيار صورة او فيديو");
    } else {
      if (isImage == true) {
        return Image.file(packedImage!);
      } else {
        v = VideoPlayerController.file(packedImage!)
          ..initialize().then((value) {})
          ..setLooping(false)
          ..pause();
        return AspectRatio(aspectRatio: 9 / 16, child: VideoPlayer(v));
      }
    }
  }

  // increaseAdsClick(int adsId) {
  //   ShopDioHelper.postData(url: "increase-clicks", data: {"ad_id": adsId})
  //       .then((value) {
  //     print("incressed");
  //     emit(CommentSuccessfulState());
  //   }).catchError((e) {
  //     emit(CommentErrorState());
  //   });
  // }

  // increaseAdsView(int adsId) {
  //   ShopDioHelper.postData(url: "increase-views", data: {"ad_id": adsId})
  //       .then((value) {
  //     emit(PostCoponSuccessful());
  //   }).catchError((e) {
  //     emit(PostCoponError());
  //   });
  // }

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

  void sendShare({required int id}) {
    emit(ShareLoadingState());
    ShopDioHelper.postData(
        token: CacheHelper.getData(key: "token"),
        url: "weather-shot/share",
        data: {"shot_id": id}).then((value) {
      print("comment send");
      emit(ShareSuccessfulState());
    }).catchError((e) {
      emit(ShareErrorState());
    });
  }

  int mainIndex = 0;

  void changeMainInedx() {
    mainIndex++;
    emit(CommentSuccessfulState());
  }
}
// AspectRatio(
//             aspectRatio: 16 / 9,
//             child: VideoPlayer(controller),
//           ),
