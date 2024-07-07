import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_tets_task/features/posts/domain/models/comment_model.dart';
import 'package:posts_tets_task/features/posts/domain/models/post_model.dart';
import 'package:posts_tets_task/features/posts/logic/comments_bloc/comments_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key, required this.post, required this.imageUrl});
  final PostModel post;
  final String imageUrl;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsBloc>().add(GetCommentsEvent(widget.post.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 12),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _ImageWidget(imageUrl: widget.imageUrl, postTitle: widget.post.title),
                    const SizedBox(height: 20),
                    Text(widget.post.body),
                    const SizedBox(height: 20),
                    const _Comments(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({required this.imageUrl, required this.postTitle});

  final String imageUrl;
  final String postTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 150,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.fitWidth)),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Text(postTitle, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _Comments extends StatelessWidget {
  const _Comments();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      builder: (context, state) {
        if (state is CommentsLoading) {
          return Column(children: List.generate(3, (index) => const _ShimmerCommentCard()));
        }
        if (state is CommentsError) {
          return Center(child: Text(state.error));
        }
        if (state is CommentsLoaded) {
          return state.comments.isEmpty
              ? const SizedBox.shrink()
              : Column(children: state.comments.map((comment) => _OneCommentWidget(comment)).toList());
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _OneCommentWidget extends StatelessWidget {
  const _OneCommentWidget(this.comment);
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.blue.shade50,
        title: Text(comment.name),
        subtitle: Text(comment.body),
      ),
    );
  }
}

class _ShimmerCommentCard extends StatelessWidget {
  const _ShimmerCommentCard();

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
              ),
            ),
          ),
        ));
  }
}
