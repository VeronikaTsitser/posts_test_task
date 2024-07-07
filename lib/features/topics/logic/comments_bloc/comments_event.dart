part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

final class GetCommentsEvent extends CommentsEvent {
  GetCommentsEvent(this.postId);
  final int postId;
}
