part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitialState extends PostsState {}

final class PostsLoadingState extends PostsState {}

final class PostsLoadedState extends PostsState {
  PostsLoadedState(this.posts, this.photos);
  final List<PostModel> posts;
  // final List<CommentModel> comments;
  final List<PhotoModel> photos;
}

final class PostsErrorState extends PostsState {
  PostsErrorState(this.error, this.stackTrace);
  final String error;
  final StackTrace stackTrace;
}
