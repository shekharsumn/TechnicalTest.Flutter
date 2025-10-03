import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/service/dio_service.dart';
import 'package:flutter_tech_task/presentation/widgets/post_list_item.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';


class ListPage extends ConsumerStatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage>
    with AutomaticKeepAliveClientMixin {
  late Future<Either<ApiError, List<Post>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    final api = ref.read(apiServiceProvider);
    _postsFuture = api.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<Either<ApiError, List<Post>>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No posts available'));
          }
          final either = snapshot.data!;
          return either.fold(
            ifLeft: (ApiError err) {
              final isConnected = ref.watch(isConnectedProvider);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isConnected ? Icons.error_outline : Icons.wifi_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isConnected ? err.message : 'No internet connection',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    if (!isConnected) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Please check your internet connection and try again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            final api = ref.read(apiServiceProvider);
                            _postsFuture = api.getPosts();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
              );
            },
            ifRight: (List<Post> posts) {
              if (posts.isEmpty) {
                return const Center(child: Text('No posts available'));
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  key: const PageStorageKey<String>('post-list'),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostListItem(post: post);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
