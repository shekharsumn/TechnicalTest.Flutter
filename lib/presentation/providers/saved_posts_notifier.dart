import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/domian/usecases/manage_saved_posts_usecase.dart';

class SavedPostsNotifier extends AsyncNotifier<List<Post>> {
  late ManageSavedPostsUseCase _manageSavedPostsUseCase;

  @override
  Future<List<Post>> build() async {
    _manageSavedPostsUseCase = ref.read(manageSavedPostsUseCaseProvider);
    // Load saved posts on initialization
    return await _manageSavedPostsUseCase.getSavedPosts();
  }

  /// Toggle save/remove a post
  Future<void> toggle(Post post) async {
    state = const AsyncValue.loading();
    try {
      await _manageSavedPostsUseCase.togglePost(post);
      final updatedPosts = await _manageSavedPostsUseCase.getSavedPosts();
      state = AsyncValue.data(updatedPosts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Explicit remove by ID
  Future<void> remove(int postId) async {
    state = const AsyncValue.loading();
    try {
      await _manageSavedPostsUseCase.removePost(postId);
      final updatedPosts = await _manageSavedPostsUseCase.getSavedPosts();
      state = AsyncValue.data(updatedPosts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Check if a post is saved
  Future<bool> isSaved(Post post) async {
    return await _manageSavedPostsUseCase.isPostSaved(post.id);
  }
}

final savedPostsProvider = AsyncNotifierProvider<SavedPostsNotifier, List<Post>>(() {
  return SavedPostsNotifier();
});