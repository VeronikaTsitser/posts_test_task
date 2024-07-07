part of 'comments_bloc.dart';

@immutable
sealed class CommentsState {}

final class CommentsInitial extends CommentsState {}

final class CommentsLoading extends CommentsState {}

final class CommentsLoaded extends CommentsState {
  CommentsLoaded(this.comments);
  final List<CommentModel> comments;
}

final class CommentsError extends CommentsState {
  CommentsError(this.error, this.stackTrace);
  final String error;
  final StackTrace stackTrace;
}
