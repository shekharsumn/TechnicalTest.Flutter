import 'package:dart_either/dart_either.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

/// Repository interface for post-related operations
/// Follows Repository pattern to abstract data sources
abstract class PostRepository {
  /// Fetch all posts from remote data source
  Future<Either<ApiError, List<Post>>> getPosts();

  /// Fetch a single post by ID from remote data source
  Future<Either<ApiError, Post>> getPostById(int id);

  /// Fetch comments for a specific post from remote data source
  Future<Either<ApiError, List<CommentModel>>> getCommentsForPost(int postId);

  /// Save a post locally for offline access
  Future<void> savePostLocally(Post post);

  /// Remove a saved post from local storage
  Future<void> removeSavedPost(int postId);

  /// Get all locally saved posts
  Future<List<Post>> getSavedPosts();

  /// Check if a specific post is saved locally
  Future<bool> isPostSaved(int postId);
}