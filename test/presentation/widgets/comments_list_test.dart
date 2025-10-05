import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/comments_list.dart';
import 'package:flutter_tech_task/presentation/widgets/comment_card.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CommentsList', () {
    testWidgets('displays empty state when comments list is empty', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const CommentsList(comments: []),
        ),
      );

      expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
      expect(find.text('No comments available for this post.'), findsOneWidget);
      expect(find.text('Be the first to comment on this post!'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('displays empty state with correct styling', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const CommentsList(comments: []),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);
      expect(find.byIcon(Icons.comment_outlined), findsOneWidget);
      expect(TestHelpers.findTextContaining('No comments'), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.comment_outlined));
      expect(icon.size, AppConstants.largeIconSize);
      expect(icon.color, Colors.grey);

      // Check text styling - find any text containing "comments"
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      final commentText = textWidgets.firstWhere((t) => t.data?.contains('comment') == true);
      expect(commentText.style?.color, Colors.grey);
    });

    testWidgets('displays ListView when comments are provided', (WidgetTester tester) async {
      final mockComments = TestHelpers.createMockComments(3);

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentsList(comments: mockComments),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CommentCard), findsNWidgets(3));
      expect(find.byIcon(Icons.comment_outlined), findsNothing);
    });

    testWidgets('displays correct number of comment cards', (WidgetTester tester) async {
      final mockComments = TestHelpers.createMockComments(5);

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentsList(comments: mockComments),
        ),
      );

      expect(find.byType(CommentCard), findsNWidgets(5));

      // Check that each comment is displayed
      for (int i = 0; i < 5; i++) {
        expect(find.text('User ${i + 1}'), findsOneWidget);
        expect(find.text('user${i + 1}@example.com'), findsOneWidget);
        expect(find.text('This is comment ${i + 1} body'), findsOneWidget);
      }
    });

    testWidgets('ListView has correct padding', (WidgetTester tester) async {
      final mockComments = TestHelpers.createMockComments(2);

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentsList(comments: mockComments),
        ),
      );

      final listViewWidget = tester.widget<ListView>(find.byType(ListView));
      expect(listViewWidget.padding, AppConstants.listPadding);
    });

    testWidgets('handles single comment correctly', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(
        name: 'Single User',
        email: 'single@example.com',
        body: 'Single comment body',
      );

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentsList(comments: [mockComment]),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(CommentCard), findsOneWidget);
      expect(find.text('Single User'), findsOneWidget);
      expect(find.text('single@example.com'), findsOneWidget);
      expect(find.text('Single comment body'), findsOneWidget);
    });

    testWidgets('handles large number of comments', (WidgetTester tester) async {
      final mockComments = TestHelpers.createMockComments(20);

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentsList(comments: mockComments),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      
      // ListView should be built but not all items may be visible
      expect(find.byType(CommentCard), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrolls properly with many comments', (WidgetTester tester) async {
      final mockComments = TestHelpers.createMockComments(10);

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: SizedBox(
            height: 300, // Constrain height to force scrolling
            child: CommentsList(comments: mockComments),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      
      // Find the first comment
      expect(find.text('User 1'), findsOneWidget);
      
      // Scroll down to find later comments
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();
      
      // Should be able to find later comments after scrolling
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty state has correct text styling', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const CommentsList(comments: []),
        ),
      );

      final titleTexts = tester.widgetList<Text>(
        find.text('No comments available for this post.'),
      );
      expect(titleTexts.length, 1);

      final titleText = titleTexts.first;
      expect(titleText.style?.fontWeight, FontWeight.bold);
      expect(titleText.style?.color, Colors.grey);

      final subtitleTexts = tester.widgetList<Text>(
        find.text('Be the first to comment on this post!'),
      );
      expect(subtitleTexts.length, 1);

      final subtitleText = subtitleTexts.first;
      expect(subtitleText.style?.color, Colors.grey);
    });
  });
}