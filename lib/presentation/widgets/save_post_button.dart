import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';

/// A reusable widget that handles save/unsave functionality for posts
/// Following Single Responsibility Principle - only handles save state logic
class SavePostButton extends ConsumerWidget {
  const SavePostButton({
    Key? key,
    required this.post,
    this.savedPosts = const [],
  }) : super(key: key);

  final Post post;
  final List<Post> savedPosts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = savedPosts.any((p) => p.id == post.id);

    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: isSaved ? Colors.blue : null,
      ),
      onPressed: () {
        ref.read(savedPostsProvider.notifier).toggle(post);
      },
    );
  }
}