import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tech_task/l10n/app_localizations.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';

/// Test helper utilities for widget testing
class TestHelpers {
  TestHelpers._();

  /// Creates a MaterialApp wrapper with localization support for testing widgets
  static Widget createTestApp({required Widget child}) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('la', ''),
        ],
      ),
    );
  }

  /// Creates a test app with Scaffold for testing widgets that need Scaffold context
  static Widget createTestAppWithScaffold({required Widget child}) {
    return createTestApp(
      child: Scaffold(body: child),
    );
  }

  /// Mock post data for testing
  static Post createMockPost({
    int id = 1,
    String title = 'Test Post Title',
    String body = 'Test post body content',
    int userId = 1,
  }) {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
    );
  }

  /// Mock comment data for testing
  static CommentModel createMockComment({
    int id = 1,
    int postId = 1,
    String name = 'John Doe',
    String email = 'john.doe@example.com',
    String body = 'This is a test comment body',
  }) {
    return CommentModel(
      id: id,
      postId: postId,
      name: name,
      email: email,
      body: body,
    );
  }

  /// Creates a list of mock comments for testing
  static List<CommentModel> createMockComments(int count) {
    return List.generate(
      count,
      (index) => createMockComment(
        id: index + 1,
        name: 'User ${index + 1}',
        email: 'user${index + 1}@example.com',
        body: 'This is comment ${index + 1} body',
      ),
    );
  }

  /// Creates a list of mock posts for testing
  static List<Post> createMockPosts(int count) {
    return List.generate(
      count,
      (index) => createMockPost(
        id: index + 1,
        title: 'Post ${index + 1} Title',
        body: 'This is post ${index + 1} body',
        userId: (index % 3) + 1,
      ),
    );
  }

  /// Pumps widget and waits for all animations to complete
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Finds text that contains the given substring
  static Finder findTextContaining(String substring) {
    return find.byWidgetPredicate(
      (widget) => widget is Text && widget.data?.contains(substring) == true,
    );
  }
}

/// Custom matchers for widget testing
class TestMatchers {
  TestMatchers._();

  /// Checks if widget has specific text style properties
  static Matcher hasTextStyle({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return predicate<Text>((widget) {
      final style = widget.style;
      if (color != null && style?.color != color) return false;
      if (fontWeight != null && style?.fontWeight != fontWeight) return false;
      if (fontSize != null && style?.fontSize != fontSize) return false;
      return true;
    });
  }

  /// Checks if Icon has specific properties
  static Matcher hasIconProperties({
    IconData? icon,
    Color? color,
    double? size,
  }) {
    return predicate<Icon>((widget) {
      if (icon != null && widget.icon != icon) return false;
      if (color != null && widget.color != color) return false;
      if (size != null && widget.size != size) return false;
      return true;
    });
  }
}