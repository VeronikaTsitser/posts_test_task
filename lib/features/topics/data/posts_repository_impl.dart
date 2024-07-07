import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:posts_tets_task/features/topics/domain/models/comment_model.dart';
import 'package:posts_tets_task/features/topics/domain/models/photo_model.dart';
import 'package:posts_tets_task/features/topics/domain/models/post_model.dart';
import 'package:posts_tets_task/features/topics/domain/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  @override
  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts/$postId/comments');
      final List<dynamic> data = response.data;
      final comments = data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList();
      log('Comments: $comments');
      return comments;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return Future.value([]);
    }
  }

  @override
  Future<List<PhotoModel>> getPhotos() async {
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/photos');
      final List<dynamic> data = response.data;
      final photos = data.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>)).toList();
      log('Photos: $photos');
      return photos;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts');
      final List<dynamic> data = response.data;
      final posts = data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
      log('Posts: $posts');
      return posts;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
  }
}
