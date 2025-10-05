import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/repository/post_repository.dart';
import 'package:flutter_tech_task/data/repository/post_repository_impl.dart';

/// Use case for managing saved posts (save/remove/toggle)
/// Encapsulates the business logic for local post management
class ManageSavedPostsUseCase {
  ManageSavedPostsUseCase(PostRepository repository) : _repository = repository;

  final PostRepository _repository;

  /// Save a post locally
  Future<void> savePost(Post post) async {
    await _repository.savePostLocally(post);
  }

  /// Remove a saved post
  Future<void> removePost(int postId) async {
    await _repository.removeSavedPost(postId);
  }

  /// Toggle save status of a post
  Future<void> togglePost(Post post) async {
    final isAlreadySaved = await _repository.isPostSaved(post.id);
    
    if (isAlreadySaved) {
      await _repository.removeSavedPost(post.id);
    } else {
      await _repository.savePostLocally(post);
    }
  }

  /// Get all saved posts
  Future<List<Post>> getSavedPosts() async {
    return await _repository.getSavedPosts();
  }

  /// Check if a post is saved
  Future<bool> isPostSaved(int postId) async {
    return await _repository.isPostSaved(postId);
  }
}

/// Riverpod provider for ManageSavedPostsUseCase
final manageSavedPostsUseCaseProvider = Provider<ManageSavedPostsUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return ManageSavedPostsUseCase(repository);
});