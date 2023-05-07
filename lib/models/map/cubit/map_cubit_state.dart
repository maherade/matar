part of 'map_cubit_cubit.dart';

@immutable
abstract class MapCubitState {}

class MapCubitInitial extends MapCubitState {}

class GetMapLoading extends MapCubitState {}

class GetMapSuccessful extends MapCubitState {}

class GetMapError extends MapCubitState {}

class GetProfLoading extends MapCubitState {}

class GetProfSuccessful extends MapCubitState {}

class GetProfError extends MapCubitState {}
