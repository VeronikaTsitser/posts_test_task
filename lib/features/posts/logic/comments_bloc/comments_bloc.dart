import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts_tets_task/features/posts/domain/models/comment_model.dart';
import 'package:posts_tets_task/features/posts/domain/posts_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostsRepository _postsRepository;
  CommentsBloc(this._postsRepository) : super(CommentsInitial()) {
    on<GetCommentsEvent>(onGetComments);
  }

  FutureOr<void> onGetComments(GetCommentsEvent event, Emitter emit) async {
    emit(CommentsLoading());

    try {
      final comments = await _postsRepository.getComments(event.postId);
      emit(CommentsLoaded(comments));
    } catch (e, st) {
      emit(CommentsError(e.toString(), st));
    }
  }
}
