import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_error_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/save_post_button.dart';
import 'package:flutter_tech_task/presentation/widgets/post_content_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/post_error_states.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';

/// Post Detail Page - Orchestrates the display of a single post
/// Following Single Responsibility Principle - focuses on page navigation and state coordination
class DetailsPage extends ConsumerWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPostByIdUseCase = ref.read(getPostByIdUseCaseProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final savedPostsAsync = ref.watch(savedPostsProvider);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final postId = args?['id'] ?? 1;

    return savedPostsAsync.when(
      data: (savedPosts) => _buildPostDetailContent(
        context, 
        ref, 
        getPostByIdUseCase, 
        isConnected, 
        savedPosts, 
        postId,
      ),
      loading: () => PostErrorStates.loading(context),
      error: (error, stackTrace) => PostErrorStates.savedPostsLoadingError(context, error),
    );
  }

  Widget _buildPostDetailContent(
    BuildContext context,
    WidgetRef ref,
    GetPostByIdUseCase getPostByIdUseCase,
    bool isConnected,
    List<Post> savedPosts,
    int postId,
  ) {
    // First check if the post is in saved posts (for offline access)
    final savedPost = savedPosts.where((p) => p.id == postId).firstOrNull;

    if (savedPost != null) {
      // Post is saved locally, show it directly
      return _buildSavedPostScaffold(context, ref, savedPost, savedPosts, isConnected);
    }

    // Post is not saved locally, need to fetch from API
    if (!isConnected) {
      // No internet and post not saved locally
      return Scaffold(
        appBar: AppBar(title: const Text('Post details')),
        body: OfflineErrorWidgets.postNotSaved(
          onGoBack: () => Navigator.of(context).pop(),
        ),
      );
    }

    // Online and post not saved locally, fetch from API using use case
    return _buildFetchPostScaffold(context, ref, getPostByIdUseCase, savedPosts, postId);
  }

  /// Builds scaffold for saved post (available offline)
  Widget _buildSavedPostScaffold(
    BuildContext context,
    WidgetRef ref,
    Post savedPost,
    List<Post> savedPosts,
    bool isConnected,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post details'),
        actions: [
          SavePostButton(post: savedPost, savedPosts: savedPosts),
        ],
      ),
      body: PostContentWidget(
        post: savedPost,
        isConnected: isConnected,
      ),
    );
  }

  /// Builds scaffold for fetching post from API
  Widget _buildFetchPostScaffold(
    BuildContext context,
    WidgetRef ref,
    GetPostByIdUseCase getPostByIdUseCase,
    List<Post> savedPosts,
    int postId,
  ) {
    return FutureBuilder<Either<ApiError, Post>>(
      future: getPostByIdUseCase.call(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PostErrorStates.loading(context);
        } else if (!snapshot.hasData) {
          return PostErrorStates.noData(context);
        }

        final either = snapshot.data!;
        return either.fold(
          ifLeft: (ApiError error) => PostErrorStates.apiError(context, error),
          ifRight: (Post post) => Scaffold(
            appBar: AppBar(
              title: const Text('Post details'),
              actions: [
                SavePostButton(post: post, savedPosts: savedPosts),
              ],
            ),
            body: PostContentWidget(
              post: post,
              isConnected: true, // Always connected when fetching from API
              showOfflineBanner: false,
            ),
          ),
        );
      },
    );
  }
}

