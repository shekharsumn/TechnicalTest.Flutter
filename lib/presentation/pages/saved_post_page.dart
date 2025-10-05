import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/presentation/widgets/saved_posts_empty_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/post_list_item.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_status_banner.dart';
import '../../l10n/app_localizations.dart';

class SavedPostPage extends ConsumerWidget {
  const SavedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPostsAsync = ref.watch(savedPostsProvider);
    final isConnected = ref.watch(isConnectedProvider);

    return savedPostsAsync.when(
      data: (savedPosts) => _buildSavedPostsContent(context, ref, savedPosts, isConnected),
      loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => ErrorDisplayWidget(
        title: AppLocalizations.of(context)!.errorLoadingSavedPostsGeneric,
        message: error.toString(),
      ),
    );
  }

  Widget _buildSavedPostsContent(BuildContext context, WidgetRef ref, List<Post> savedPosts, bool isConnected) {

    if (savedPosts.isEmpty) {
      return SavedPostsEmptyWidget(isConnected: isConnected);
    }

    return Column(
      children: [
        if (!isConnected)
          OfflineStatusBanner(
            message: AppLocalizations.of(context)!.offlineModeShowingSavedPostsOnly,
          ),
        Expanded(
          child: ListView.builder(
            itemCount: savedPosts.length,
            itemBuilder: (context, index) {
              final post = savedPosts[index];
              return PostListItem(
                post: post,
                trailingAction: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(savedPostsProvider.notifier).remove(post.id);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}