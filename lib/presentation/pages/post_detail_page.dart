import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/service/dio_service.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';


class DetailsPage extends ConsumerWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.read(apiServiceProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final savedPosts = ref.watch(savedPostsProvider);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final postId = args?['id'] ?? 1;

    // First check if the post is in saved posts (for offline access)
    final savedPost = savedPosts.where((p) => p.id == postId).firstOrNull;

    if (savedPost != null) {
      // Post is saved locally, show it directly
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post details'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: Colors.blue,
              ),
              onPressed: () {
                ref.read(savedPostsProvider.notifier).toggle(savedPost);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (!isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Offline mode - showing saved post',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: PostDetails(post: savedPost)),
          ],
        ),
      );
    }

    // Post is not saved locally, need to fetch from API
    if (!isConnected) {
      // No internet and post not saved locally
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This post is not saved locally.\nConnect to internet to view it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Online and post not saved locally, fetch from API
    return FutureBuilder<Either<ApiError, Post>>(
      future: api.getPostById(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Post details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Post details')),
            body: const Center(child: Text('No data available')),
          );
        }

        final either = snapshot.data!;
        return either.fold(
          ifLeft: (ApiError err) {
            return Scaffold(
              appBar: AppBar(title: const Text('Post details')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      err.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          },
          ifRight: (Post post) {
            // Watch saved posts provider to reflect current state
            final isSaved = ref.watch(savedPostsProvider).any((p) => p.id == post.id);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Post details'),
                actions: [
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.blue : null,
                    ),
                    onPressed: () {
                      ref.read(savedPostsProvider.notifier).toggle(post);
                    },
                  ),
                ],
              ),
              body: PostDetails(post: post),
            );
          },
        );
      },
    );
  }
}

/// Separate widget for displaying post details
class PostDetails extends StatelessWidget {
  const PostDetails({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(post.body, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}