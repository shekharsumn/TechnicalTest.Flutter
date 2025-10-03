import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';

class PostListItem extends ConsumerWidget {

  const PostListItem({
    Key? key, 
    required this.post,
    this.trailingAction,
    this.showBookmarkToggle = true,
  }) : super(key: key);
  
  final Post post;
  
  /// Custom trailing widget to override the default bookmark toggle
  final Widget? trailingAction;
  
  /// Whether to show the default bookmark toggle (ignored if trailingAction is provided)
  final bool showBookmarkToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the async saved posts state
    final savedPostsAsync = ref.watch(savedPostsProvider);
    
    // Extract the saved posts list, defaulting to empty list if loading/error
    final savedPosts = savedPostsAsync.when(
      data: (posts) => posts,
      loading: () => <Post>[],
      error: (_, __) => <Post>[],
    );
    
    // Optimized: Only check if this specific post is saved
    final isSaved = savedPosts.any((p) => p.id == post.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: _buildTrailingWidget(ref, isSaved),
        onTap: () {
          Navigator.of(context).pushNamed(
            'details/',
            arguments: {'id': post.id},
          );
        },
      ),
    );
  }

  /// Builds the trailing widget based on configuration
  Widget _buildTrailingWidget(WidgetRef ref, bool isSaved) {
    // If custom trailing action is provided, use it
    if (trailingAction != null) {
      return trailingAction!;
    }
    
    // If bookmark toggle is disabled, return empty widget
    if (!showBookmarkToggle) {
      return const SizedBox.shrink();
    }
    
    // Default bookmark toggle behavior
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