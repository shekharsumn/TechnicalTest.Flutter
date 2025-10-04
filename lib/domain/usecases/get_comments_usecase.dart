import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/repository/post_repository.dart';
import 'package:flutter_tech_task/data/repository/post_repository_impl.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

/// Use case for fetching comments for a specific post
/// Encapsulates the business logic for getting post comments
class GetCommentsUseCase {
  GetCommentsUseCase({required PostRepository repository}) : _repository = repository;

  final PostRepository _repository;

  /// Execute the use case to get comments for a post
  Future<Either<ApiError, List<CommentModel>>> call(int postId) async {
    return await _repository.getCommentsForPost(postId);
  }
}

/// Riverpod provider for GetCommentsUseCase
final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return GetCommentsUseCase(repository: repository);
});