import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/repository/post_repository.dart';
import 'package:flutter_tech_task/data/repository/post_repository_impl.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

/// Use case for fetching all posts
/// Encapsulates the business logic for getting posts
class GetPostsUseCase {
  GetPostsUseCase({required PostRepository repository}) : _repository = repository;

  final PostRepository _repository;

  /// Executes the use case to get all posts.
  ///
  /// Returns an [Either] containing an [ApiError] on failure,
  /// or a [List<Post>] on success.
  Future<Either<ApiError, List<Post>>> call() async {
    return await _repository.getPosts();
  }
}

/// Riverpod provider for GetPostsUseCase
final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return GetPostsUseCase(repository: repository);
});