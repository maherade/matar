import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/dio%20helper/dio_helper.dart';
import 'package:meta/meta.dart';

part 'forget_pass_state.dart';

class ForgetPassCubit extends Cubit<ForgetPassState> {
  ForgetPassCubit() : super(ForgetPassInitial());

  static ForgetPassCubit caller(context) => BlocProvider.of(context);

  void sendVerLinke(String email) {
    emit(SendLinkeLoading());
    ShopDioHelper.postPass(url: "https://admin.rain-app.com/api/send-reset-password", data: {"email": email})
        .then((value) {
      print("link sent");
      emit(SendLinkeSuccess());
    }).catchError((e) {
      emit(SendLinkeError());
    });
  }

  void changePassword(String password, String email) {
    emit(ChangePasswordLoading());
    ShopDioHelper.postPass(
            url: "https://admin.rain-app.com/api/reset-password",
            data: {"email": email, "code": code, "password": password})
        .then((value) {
      emit(ChangePasswordSuccess());
    }).catchError((e) {
      emit(ChangePasswordError());
    });
  }

  String? code;

  void checkCode(String c, String password, String email) {
    emit(CheckCodeLoading());
    ShopDioHelper.postPass(
        url: "https://admin.rain-app.com/api/check-reset-code",
        data: {"email": email, "code": c}).then((value) {
      code = c;
      changePassword(password, email);
      emit(CheckCodeSucess());
    }).catchError((e) {
      emit(CheckCodeError());
    });
  }
}
