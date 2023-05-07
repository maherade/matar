part of 'forget_pass_cubit.dart';

@immutable
abstract class ForgetPassState {}

class ForgetPassInitial extends ForgetPassState {}

class SendLinkeLoading extends ForgetPassState {}

class SendLinkeSuccess extends ForgetPassState {}

class SendLinkeError extends ForgetPassState {}

class ChangePasswordLoading extends ForgetPassState {}

class ChangePasswordSuccess extends ForgetPassState {}

class ChangePasswordError extends ForgetPassState {}

class CheckCodeLoading extends ForgetPassState {}

class CheckCodeSucess extends ForgetPassState {}

class CheckCodeError extends ForgetPassState {}
