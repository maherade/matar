part of 'app_cubit.dart';

@immutable
abstract class ApppState {}

class AppInitial extends ApppState {}

class ChangeLoginPasswordVisibility extends ApppState {}

class ShopLoginLoadingState extends ApppState {}

class ShopLoginSuccessState extends ApppState {}

class ShopLoginErrorState extends ApppState {
  ShopLoginErrorState(String error);
}

class SignUpLoadingState extends ApppState {}

class SignUpSuccessState extends ApppState {}

class SignUpErrorState extends ApppState {
  SignUpErrorState(String error);
}

class BottomNavState extends ApppState {}

class GetDataLoadingState extends ApppState {}

class GetDataSuccessState extends ApppState {}

class GetDataErrorState extends ApppState {}

class UserSharedLoading extends ApppState {}

class UserSharedSuccess extends ApppState {}

class UserSharedError extends ApppState {}

class GetWeatherPostsLoading extends ApppState {}

class GetWeatherPostsSuccess extends ApppState {}

class GetWeatherPostsError extends ApppState {}

class UpdateUserLoading extends ApppState {}

class UpdateUserSuccess extends ApppState {}

class UpdateUserError extends ApppState {}

class ImagePickedSuccessful extends ApppState {}

class CommentLoadingState extends ApppState {}

class CommentSuccessfulState extends ApppState {}

class CommentErrorState extends ApppState {}

class LikeLoadingState extends ApppState {}

class LikeSuccessfulState extends ApppState {}

class LikeErrorState extends ApppState {}

class ShareLoadingState extends ApppState {}

class ShareSuccessfulState extends ApppState {}

class ShareErrorState extends ApppState {}

class GetProfileLoading extends ApppState {}

class GetProfileSuccessful extends ApppState {}

class GetProfileError extends ApppState {}

class PostCoponLoading extends ApppState {}

class PostCoponSuccessful extends ApppState {}

class PostCoponError extends ApppState {}

class GetAdsLoading extends ApppState {}

class GetAdsSuccessful extends ApppState {}

class GetAdsError extends ApppState {}

class InitAd extends ApppState {}

class ChangeMapState extends ApppState {}

class GoogleSignInLoading extends ApppState {}

class GoogleSignInSuccessful extends ApppState {}

class GoogleSignInError extends ApppState {}

class GoogleSignOut extends ApppState {}

class ShowCommentDone extends ApppState {}

class GoToFirstPageState extends ApppState {}

class ConnectedState extends ApppState {}

class NotConnectedState extends ApppState {}

class AddComment extends ApppState {}

class CahngePageViewInd extends ApppState {}

class CahngeCountryState extends ApppState {}
