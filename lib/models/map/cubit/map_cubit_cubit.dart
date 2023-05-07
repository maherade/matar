import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../dio helper/dio_helper.dart';
import '../../../module/map_model.dart';

part 'map_cubit_state.dart';

class MapCubitCubit extends Cubit<MapCubitState> {
  MapCubitCubit() : super(MapCubitInitial());

  static MapCubitCubit caller(context) => BlocProvider.of(context);
  MapModel? mapModel;

  void getmapDetails() {
    emit(GetMapLoading());
    ShopDioHelper.getData(url: "sattelite-link").then((value) {
      mapModel = MapModel.fromJson(value.data);
      print("map done");
      emit(GetMapError());
    }).catchError((e) {});
  }
}
