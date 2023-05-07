part of 'video_cubit.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class GetVideoLoadingState extends VideoState {}

class GetVideoSuccessState extends VideoState {}

class GetVideoErrorState extends VideoState {}

class VideoPickedSuccessful extends VideoState {}

class VideoInitState extends VideoState {}

class uploadFileLoadingState extends VideoState {}

class uploadFileSuccessState extends VideoState {}

class uploadFileErrorState extends VideoState {}

class CommentSuccessfulState extends VideoState {}

class CommentErrorState extends VideoState {}

class PostCoponSuccessful extends VideoState {}

class PostCoponError extends VideoState {}

class GetAdsLoading extends VideoState {}

class GetAdsSuccessful extends VideoState {}

class GetAdsError extends VideoState {}

class ShareLoadingState extends VideoState {}

class ShareSuccessfulState extends VideoState {}

class ShareErrorState extends VideoState {}

class IndexChanged extends VideoState {}
