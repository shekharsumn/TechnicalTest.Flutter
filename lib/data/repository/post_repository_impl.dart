import 'dart:convert';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/data/repository/post_repository.dart';
import 'package:flutter_tech_task/data/service/api_interface.dart';
import 'package:flutter_tech_task/data/service/dio_service.dart';
import 'package:flutter_tech_task/data/service/shared_preferences_service.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

/// Concrete implementation of PostRepository
/// Handles both remote API calls and local storage operations
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required ApiInterface apiService,
  }) : _apiService = apiService;

  final ApiInterface _apiService;
  static const String _savedPostsKey = 'saved_posts';

  List<Post>? _cachedSavedPosts;

  /// Cached SharedPreferencesService instance
  SharedPreferencesService? _prefsServiceInstance;

  /// Get SharedPreferencesService instance (cached)
  Future<SharedPreferencesService> get _prefsService async {
    if (_prefsServiceInstance != null) {
      return _prefsServiceInstance!;
    }
    _prefsServiceInstance = await SharedPreferencesService.getInstance();
    return _prefsServiceInstance!;
  }

  @override
  Future<Either<ApiError, List<Post>>> getPosts() async {
    return await _apiService.getPosts();
  }

  @override
  Future<Either<ApiError, Post>> getPostById(int id) async {
    return await _apiService.getPostById(id);
  }

  @override
  Future<Either<ApiError, List<CommentModel>>> getCommentsForPost(
      int postId) async {
    return await _apiService.getCommentsForPost(postId);
  }

  @override

  /// Saves a post locally to shared preferences, avoiding duplicates.
  Future<void> savePostLocally(Post post) async {
    final prefsService = await _prefsService;
    // Only call getSavedPosts once and reuse the result
    final List<Post> savedPosts = await getSavedPosts();

    // Avoid duplicates
    if (!savedPosts.any((p) => p.id == post.id)) {
      savedPosts.add(post);
      final jsonStringList =
          savedPosts.map((p) => json.encode(p.toJson())).toList();
      await prefsService.setStringList(_savedPostsKey, jsonStringList);
      _cachedSavedPosts = null; // Invalidate cache
    }
  }

  /// Removes a saved post from local storage by its [postId].
  /// Updates the local cache and persistent storage accordingly.
  @override
  Future<void> removeSavedPost(int postId) async {
    final prefsService = await _prefsService;
    // Only call getSavedPosts once and reuse the result
    final List<Post> savedPosts = await getSavedPosts();
    savedPosts.removeWhere((p) => p.id == postId);

    final jsonStringList =
        savedPosts.map((p) => json.encode(p.toJson())).toList();
    await prefsService.setStringList(_savedPostsKey, jsonStringList);
    _cachedSavedPosts = null; // Invalidate cache
  }

  @override
  Future<List<Post>> getSavedPosts() async {
    if (_cachedSavedPosts != null) {
      return _cachedSavedPosts!;
    }
    final prefsService = await _prefsService;
    final jsonStringList = prefsService.getStringList(_savedPostsKey) ?? [];
    final List<Post> posts = [];
    for (final jsonStr in jsonStringList) {
      try {
        posts.add(Post.fromJson(json.decode(jsonStr)));
      } catch (e) {
        // Skip malformed or corrupted entries
        continue;
      }
    }
    _cachedSavedPosts = posts;
    return _cachedSavedPosts!;
  }

  /// Checks if a post with [postId] is saved locally.
  @override
  Future<bool> isPostSaved(int postId) async {
    final savedPosts = await getSavedPosts();
    return savedPosts.any((p) => p.id == postId);
  }
}

/// Riverpod provider for PostRepository
/// Provides a singleton instance of PostRepository for dependency injection via Riverpod.
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final apiService = ref.read(dioServiceProvider);
  return PostRepositoryImpl(apiService: apiService);
});
