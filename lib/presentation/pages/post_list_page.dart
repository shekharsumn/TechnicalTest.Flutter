import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_tech_task/presentation/widgets/post_list_item.dart';
import 'package:flutter_tech_task/presentation/widgets/api_error_widget.dart';
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
    final getPostsUseCase = ref.read(getPostsUseCaseProvider);
    _postsFuture = getPostsUseCase.call();
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
              return ApiErrorWidget(
                isConnected: isConnected,
                error: err.message,
                onRetry: () {
                  setState(() {
                    final getPostsUseCase = ref.read(getPostsUseCaseProvider);
                    _postsFuture = getPostsUseCase.call();
                  });
                },
                offlineSubtitle: 'Please check your internet connection and try again',
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
