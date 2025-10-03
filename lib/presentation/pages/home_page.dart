import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/post_list_page.dart';
import 'package:flutter_tech_task/presentation/pages/saved_post_page.dart';
import 'package:flutter_tech_task/presentation/providers/saved_posts_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCount = ref.watch(savedPostsProvider).length;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'All'),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Saved'),
                    if (savedCount > 0) ...[
                      const SizedBox(width: 6),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$savedCount',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListPage(),
            SavedPostPage(),
          ],
        ),
      ),
    );
  }
}