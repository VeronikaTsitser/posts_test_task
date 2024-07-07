import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:posts_tets_task/features/topics/logic/comments_bloc/comments_bloc.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = (ModalRoute.of(context)!.settings.arguments as List).first;
    final photoUrl = (ModalRoute.of(context)!.settings.arguments as List).last;

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
                    Container(
                        height: 150,
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(photoUrl, fit: BoxFit.fitWidth)),
                    const SizedBox(height: 20),
                    MarkdownBody(data: post.body),
                    const SizedBox(height: 20),
                    BlocBuilder<CommentsBloc, CommentsState>(
                      builder: (context, state) {
                        if (state is CommentsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is CommentsError) {
                          return Center(child: Text(state.error));
                        }
                        if (state is CommentsLoaded) {
                          return Column(
                            children: state.comments
                                .map(
                                  (comment) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      tileColor: Colors.blue.shade50,
                                      title: Text(comment.name),
                                      subtitle: Text(comment.body),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
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
