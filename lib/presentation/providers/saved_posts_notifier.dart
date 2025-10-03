import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';

class SavedPostsNotifier extends StateNotifier<List<Post>> {

  SavedPostsNotifier() : super([]) {
    _loadFromPrefs();
  }
  static const String _storageKey = 'saved_posts';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList(_storageKey) ?? [];
    final posts = jsonStringList
        .map((jsonStr) => Post.fromJson(json.decode(jsonStr)))
        .toList();
    state = posts;
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList =
        state.map((post) => json.encode(post.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonStringList);
  }

  /// Toggle save/remove
  void toggle(Post post) {
    if (state.any((p) => p.id == post.id)) {
      remove(post.id);
    } else {
      state = [...state, post];
      _saveToPrefs();
    }
  }

  /// Explicit remove by ID
  void remove(int postId) {
    state = state.where((p) => p.id != postId).toList();
    _saveToPrefs();
  }

  bool isSaved(Post post) {
    return state.any((p) => p.id == post.id);
  }
}

final savedPostsProvider =
    StateNotifierProvider<SavedPostsNotifier, List<Post>>((ref) {
  return SavedPostsNotifier();
});