import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle SharedPreferences operations
/// Eliminates repeated SharedPreferences.getInstance() calls and centralizes local storage logic
class SharedPreferencesService {
  SharedPreferencesService._();
  
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;
  
  /// Get singleton instance of SharedPreferencesService
  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }
  
  /// Get string list from shared preferences
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }
  
  /// Set string list in shared preferences
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }
  
  /// Remove key from shared preferences
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }
  
  /// Check if key exists in shared preferences
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
  
  /// Clear all shared preferences
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}

/// Riverpod provider for SharedPreferencesService
final sharedPreferencesServiceProvider = Provider<Future<SharedPreferencesService>>((ref) {
  return SharedPreferencesService.getInstance();
});