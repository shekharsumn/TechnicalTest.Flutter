import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/service/dio_service.dart';
import 'package:flutter_tech_task/presentation/widgets/post_list_item.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_tech_task/utils/api_error.dart';


class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.read(apiServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of posts'),
      ),
      body: FutureBuilder<Either<ApiError, List<Post>>>(
        future: api.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No posts available'));
          }
          final either = snapshot.data!;
          return either.fold(
            ifLeft: (ApiError err) {
              return Center(child: Text(err.message));
            },
            ifRight: (List<Post> posts) {
              if (posts.isEmpty) {
                return const Center(child: Text('No posts available'));
              }
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostListItem(post: post);
                },
              );
            },
          );
        },
      ),
    );
  }
}
