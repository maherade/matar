part of 'country_cubit.dart';

@immutable
abstract class CountryState {}

class CountryInitial extends CountryState {}

class GetCountryLoading extends CountryState {}

class GetCountrySuccess extends CountryState {}

class GetCountryError extends CountryState {}
