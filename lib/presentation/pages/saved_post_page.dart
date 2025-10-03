import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';

class SavedPostPage extends ConsumerWidget {
  const SavedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPosts = ref.watch(savedPostsProvider);
    final isConnected = ref.watch(isConnectedProvider);

    if (savedPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnected ? Icons.bookmark_border : Icons.wifi_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isConnected 
                ? 'No saved posts' 
                : 'No internet connection\nSaved posts will appear here when you save them',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (!isConnected) ...[
              const SizedBox(height: 8),
              const Text(
                'Connect to internet to load new posts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
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
                    'Offline mode - showing saved posts only',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: savedPosts.length,
            itemBuilder: (context, index) {
              final post = savedPosts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(savedPostsProvider.notifier).remove(post.id);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      'details/',
                      arguments: {'id': post.id},
                    );
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