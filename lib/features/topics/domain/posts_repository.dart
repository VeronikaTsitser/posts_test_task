import 'package:posts_tets_task/features/topics/domain/models/comment_model.dart';
import 'package:posts_tets_task/features/topics/domain/models/photo_model.dart';
import 'package:posts_tets_task/features/topics/domain/models/post_model.dart';

abstract class PostsRepository {
  Future<List<PostModel>> getPosts();
  Future<List<CommentModel>> getComments(int postId);
  Future<List<PhotoModel>> getPhotos();
}
