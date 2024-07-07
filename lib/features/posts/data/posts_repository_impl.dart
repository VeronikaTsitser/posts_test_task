import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:posts_tets_task/features/posts/domain/models/comment_model.dart';
import 'package:posts_tets_task/features/posts/domain/models/photo_model.dart';
import 'package:posts_tets_task/features/posts/domain/models/post_model.dart';
import 'package:posts_tets_task/features/posts/domain/posts_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl();
  @override
  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final commentsStr = pref.getStringList(_postCommentsKey(postId));
      if (commentsStr != null) {
        final comments = commentsStr.map((e) => CommentModel.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
        return comments;
      }
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts/$postId/comments');
      final List<dynamic> data = response.data;
      final comments = data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList();

      await pref.setStringList(_postCommentsKey(postId), comments.map((e) => jsonEncode(e).toString()).toList());
      return comments;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return Future.value([]);
    }
  }

  String _postCommentsKey(int postId) => 'comments_$postId';

  @override
  Future<List<PhotoModel>> getPhotos() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final photosStr = pref.getStringList('photos');
      if (photosStr != null) {
        final photos = photosStr.map((e) => PhotoModel.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
        return photos;
      }
      final response = await Dio().get('https://jsonplaceholder.typicode.com/photos');
      final List<dynamic> data = response.data;
      final photos = data.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>)).toList();
      await pref.setStringList('photos', photos.map((e) => jsonEncode(e).toString()).toList());
      return photos;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final postsStr = pref.getStringList('posts');
      if (postsStr != null) {
        final posts = postsStr.map((e) => PostModel.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
        return posts;
      }
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts');
      final List<dynamic> data = response.data;
      final posts = data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
      await pref.setStringList('posts', posts.map((e) => jsonEncode(e).toString()).toList());
      return posts;
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return [];
    }
  }
}
