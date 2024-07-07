import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';
import 'package:posts_tets_task/features/posts/domain/models/post_model.dart';
import 'package:posts_tets_task/features/posts/logic/comments_bloc/comments_bloc.dart';
import 'package:posts_tets_task/features/posts/logic/post_bloc/posts_bloc.dart';
import 'package:posts_tets_task/features/posts/presentation/post_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class PostsListScreen extends StatelessWidget {
  const PostsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(title: const Text('Posts List')),
      body: SafeArea(
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoadingState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 12),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => const _ShimmerTopicCard(),
                ),
              );
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

class _ShimmerTopicCard extends StatelessWidget {
  const _ShimmerTopicCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.grey.shade400, Colors.grey.shade100],
        ),
        direction: ShimmerDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tileColor: Colors.grey.shade200,
            title: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                )),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const ColoredBox(
                color: Colors.grey,
                child: SizedBox.square(dimension: 60),
              ),
            ),
          ),
        ));
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostDetailsScreen(post: post, imageUrl: imageURL),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.grey.shade200,
        title: Text(
          post.body,
          maxLines: 3,
          overflow: TextOverflow.fade,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.square(
            dimension: 60,
            child: OctoImage(
              image: CachedNetworkImageProvider(imageURL),
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
