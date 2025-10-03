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

  /// Get SharedPreferencesService instance
  Future<SharedPreferencesService> get _prefsService async {
    return await SharedPreferencesService.getInstance();
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
  Future<Either<ApiError, List<CommentModel>>> getCommentsForPost(int postId) async {
    return await _apiService.getCommentsForPost(postId);
  }

  @override
  Future<void> savePostLocally(Post post) async {
    final prefsService = await _prefsService;
    final savedPosts = await getSavedPosts();
    
    // Avoid duplicates
    if (!savedPosts.any((p) => p.id == post.id)) {
      savedPosts.add(post);
      final jsonStringList = savedPosts.map((p) => json.encode(p.toJson())).toList();
      await prefsService.setStringList(_savedPostsKey, jsonStringList);
    }
  }

  @override
  Future<void> removeSavedPost(int postId) async {
    final prefsService = await _prefsService;
    final savedPosts = await getSavedPosts();
    savedPosts.removeWhere((p) => p.id == postId);
    
    final jsonStringList = savedPosts.map((p) => json.encode(p.toJson())).toList();
    await prefsService.setStringList(_savedPostsKey, jsonStringList);
  }

  @override
  Future<List<Post>> getSavedPosts() async {
    final prefsService = await _prefsService;
    final jsonStringList = prefsService.getStringList(_savedPostsKey) ?? [];
    return jsonStringList
        .map((jsonStr) => Post.fromJson(json.decode(jsonStr)))
        .toList();
  }

  @override
  Future<bool> isPostSaved(int postId) async {
    final savedPosts = await getSavedPosts();
    return savedPosts.any((p) => p.id == postId);
  }
}

/// Riverpod provider for PostRepository
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PostRepositoryImpl(apiService: apiService);
});