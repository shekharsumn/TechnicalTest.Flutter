import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

class PostListNotifier extends AsyncNotifier<Either<ApiError, List<Post>>> {

  late final GetPostsUseCase _getPostsUseCase;

  @override
  Future<Either<ApiError, List<Post>>> build() async {
    // Initial state can be set here if needed
    _getPostsUseCase = ref.read(getPostsUseCaseProvider);
    return fetchPosts();
  }

  Future<Either<ApiError, List<Post>>> fetchPosts() async {
    // Logic to fetch posts and update the state
    state = const AsyncValue.loading();
    final posts = await _getPostsUseCase.call();
    state = AsyncValue.data(posts);
    return posts;
  }
}

final postListProvider = AsyncNotifierProvider<PostListNotifier, Either<ApiError, List<Post>>>(() {
  return PostListNotifier();
});