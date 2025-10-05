import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/save_post_button.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('SavePostButton', () {
    testWidgets('shows bookmark_border icon when post is not saved', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost();
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: mockPost,
            savedPosts: const [], // Empty list means post is not saved
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.bookmark_border));
      expect(iconWidget.color, isNull); // Should not have color when not saved
    });

    testWidgets('shows bookmark icon when post is saved', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost(id: 1);
      final savedPosts = [mockPost]; // Post is in saved list
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: mockPost,
            savedPosts: savedPosts,
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.bookmark));
      expect(iconWidget.color, Colors.blue);
    });

    testWidgets('correctly identifies saved state with multiple posts', (WidgetTester tester) async {
      final targetPost = TestHelpers.createMockPost(id: 2);
      final savedPosts = [
        TestHelpers.createMockPost(id: 1),
        TestHelpers.createMockPost(id: 2), // Target post is saved
        TestHelpers.createMockPost(id: 3),
      ];
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: targetPost,
            savedPosts: savedPosts,
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.bookmark));
      expect(iconWidget.color, Colors.blue);
    });

    testWidgets('correctly identifies unsaved state with multiple posts', (WidgetTester tester) async {
      final targetPost = TestHelpers.createMockPost(id: 5);
      final savedPosts = [
        TestHelpers.createMockPost(id: 1),
        TestHelpers.createMockPost(id: 2),
        TestHelpers.createMockPost(id: 3),
      ];
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: targetPost,
            savedPosts: savedPosts,
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.bookmark_border));
      expect(iconWidget.color, isNull);
    });

    testWidgets('is an IconButton widget', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost();
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: mockPost,
            savedPosts: const [],
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('handles empty saved posts list', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost();
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: mockPost,
            savedPosts: const [],
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles post with same ID but different content', (WidgetTester tester) async {
      final targetPost = TestHelpers.createMockPost(id: 1, title: 'Original Title');
      final savedPost = TestHelpers.createMockPost(id: 1, title: 'Different Title');
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: targetPost,
            savedPosts: [savedPost],
          ),
        ),
      );

      // Should still show as saved because ID matches
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('button is tappable and does not throw errors', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost();
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SavePostButton(
            post: mockPost,
            savedPosts: const [],
          ),
        ),
      );

      // Tap the button - should not throw any errors
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      
      expect(tester.takeException(), isNull);
    });
  });
}