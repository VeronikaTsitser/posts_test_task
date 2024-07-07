import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';
import 'package:posts_tets_task/features/topics/domain/models/post_model.dart';
import 'package:posts_tets_task/features/topics/logic/comments_bloc/comments_bloc.dart';
import 'package:posts_tets_task/features/topics/logic/post_bloc/posts_bloc.dart';

class PostsListScreen extends StatelessWidget {
  const PostsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics List')),
      body: SafeArea(
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PostsErrorState) {
              return Center(child: Text(state.error));
            }
            if (state is PostsLoadedState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 12),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TopicsListCard(
                          post: state.posts[index],
                          imageURL: state.photos[index].url,
                        ),
                        childCount: state.posts.length,
                      ),
                    )
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class TopicsListCard extends StatelessWidget {
  const TopicsListCard({super.key, required this.post, required this.imageURL});

  final PostModel post;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: () {
          context.read<CommentsBloc>().add(GetCommentsEvent(post.id));
          Navigator.of(context).pushNamed('/post_details', arguments: [post, imageURL]);
        },
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.grey.shade200,
        title: Text(post.body),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.square(
            dimension: 60,
            child: OctoImage(
              image: NetworkImage(imageURL),
              fit: BoxFit.cover,
              fadeInCurve: Curves.easeInOut,
              fadeInDuration: const Duration(milliseconds: 500),
              placeholderBuilder: (context) => const ColoredBox(
                color: Colors.white,
                child: SizedBox.square(dimension: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
