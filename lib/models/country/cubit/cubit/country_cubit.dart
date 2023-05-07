import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mattar/dio%20helper/dio_helper.dart';
import 'package:mattar/module/country%20model.dart';
import 'package:meta/meta.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  static CountryCubit caller(context) => BlocProvider.of(context);
  List<CountryModel> countries = [];

  getCountry() {
    print("object");
    emit(GetCountryLoading());
    ShopDioHelper.getData(url: "countries").then((value) {
      value.data.forEach((element) {
        countries.add(CountryModel.fromJson(element));
        print("ةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةةة");
      });
      emit(GetCountrySuccess());
    }).catchError((e) {
      emit(GetCountryError());
    });
  }
}
