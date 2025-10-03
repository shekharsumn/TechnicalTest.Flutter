import 'package:dart_either/dart_either.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';

/// Abstraction for API methods used by the app.
/// Returns Either to wrap successful data or a DioException for failures.
abstract class ApiInterface {
  /// Fetch all posts
  Future<Either<ApiError, List<Post>>> getPosts();

  /// Fetch a single post by id
  Future<Either<ApiError, Post>> getPostById(int id);

  /// Fetch comments for a given post id
  Future<Either<ApiError, List<CommentModel>>> getCommentsForPost(int postId);
}

