import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/comment_card.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CommentCard', () {
    testWidgets('displays comment data correctly', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(
        name: 'John Doe',
        email: 'john.doe@example.com',
        body: 'This is a test comment',
      );

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('This is a test comment'), findsOneWidget);
    });

    testWidgets('displays user avatar with correct initial', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(name: 'Alice Smith');

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      final avatarWidget = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatarWidget.radius, AppConstants.avatarRadius);
    });

    testWidgets('displays fallback initial when name is empty', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(name: '');

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      expect(find.text('U'), findsOneWidget);
    });

    testWidgets('has correct card styling', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment();

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      final cardWidget = tester.widget<Card>(find.byType(Card));
      expect(cardWidget.margin, AppConstants.commentCardMargin);
      expect(cardWidget.elevation, AppConstants.commentCardElevation);

      final shape = cardWidget.shape as RoundedRectangleBorder;
      final borderRadius = shape.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, AppConstants.commentCardBorderRadius);
    });

    testWidgets('has correct layout structure', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment();

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('displays comment body with correct styling', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(
        body: 'This is a long comment body that should wrap properly.',
      );

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      final bodyTexts = tester.widgetList<Text>(find.text(mockComment.body));
      expect(bodyTexts.length, 1);

      final bodyText = bodyTexts.first;
      expect(bodyText.style?.height, AppConstants.commentBodyLineHeight);
    });

    testWidgets('displays name with bold font weight', (WidgetTester tester) async {
      final testComment = CommentModel(
        id: 1,
        postId: 1,
        name: 'Test User',
        email: 'test@example.com',
        body: 'Test comment body',
      );

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: testComment),
        ),
      );

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.length, greaterThanOrEqualTo(1));
      
      // Find the name text widget and verify it has bold styling
      final nameTextWidget = textWidgets.firstWhere(
        (text) => text.data == 'Test User',
        orElse: () => textWidgets.first,
      );
      expect(nameTextWidget.style?.fontWeight, anyOf(FontWeight.bold, FontWeight.w600, FontWeight.w700));
    });

    testWidgets('displays email with grey color', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(email: 'test@example.com');

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      final emailTexts = tester.widgetList<Text>(find.text('test@example.com'));
      expect(emailTexts.length, 1);

      final emailText = emailTexts.first;
      expect(emailText.style?.color, Colors.grey[600]);
    });

    testWidgets('handles long content gracefully', (WidgetTester tester) async {
      final mockComment = TestHelpers.createMockComment(
        name: 'Very Long Name That Should Not Break Layout',
        email: 'very.long.email.address@example.com',
        body: 'This is a very long comment body that contains multiple sentences. '
              'It should wrap properly and not cause any layout issues. '
              'The text should remain readable and properly formatted.',
      );

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: CommentCard(comment: mockComment),
        ),
      );

      expect(find.text(mockComment.name), findsOneWidget);
      expect(find.text(mockComment.email), findsOneWidget);
      expect(find.text(mockComment.body), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}