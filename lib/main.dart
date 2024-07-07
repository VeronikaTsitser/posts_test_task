import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_tets_task/features/topics/data/posts_repository_impl.dart';
import 'package:posts_tets_task/features/topics/domain/posts_repository.dart';
import 'package:posts_tets_task/features/topics/logic/comments_bloc/comments_bloc.dart';
import 'package:posts_tets_task/features/topics/logic/post_bloc/posts_bloc.dart';
import 'package:posts_tets_task/features/topics/presentation/post_details_screen.dart';
import 'package:posts_tets_task/features/topics/presentation/posts_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<PostsRepository>(create: (context) => PostsRepositoryImpl()),
        BlocProvider(create: (context) => PostsBloc(context.read<PostsRepository>())..add(GetPostsEvent())),
        BlocProvider(create: (context) => CommentsBloc(context.read<PostsRepository>())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const PostsListScreen(),
        routes: {
          '/post_details': (context) => const PostDetailsScreen(),
        },
      ),
    );
  }
}
