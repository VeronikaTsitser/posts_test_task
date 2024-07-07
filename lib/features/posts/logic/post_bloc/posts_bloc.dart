import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts_tets_task/features/posts/domain/models/photo_model.dart';
import 'package:posts_tets_task/features/posts/domain/models/post_model.dart';
import 'package:posts_tets_task/features/posts/domain/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _postsRepository;
  PostsBloc(this._postsRepository) : super(PostsInitialState()) {
    on<GetPostsEvent>(onGetPostsEvent);
  }

  FutureOr<void> onGetPostsEvent(GetPostsEvent event, Emitter emit) async {
    emit(PostsLoadingState());
    try {
      final posts = await _postsRepository.getPosts();
      final photos = await _postsRepository.getPhotos();
      emit(PostsLoadedState(posts, photos));
    } catch (e) {
      emit(PostsErrorState(e.toString(), StackTrace.current));
    }
  }
}
