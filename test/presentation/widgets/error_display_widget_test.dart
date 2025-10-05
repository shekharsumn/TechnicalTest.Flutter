import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('displays title and message correctly', (WidgetTester tester) async {
      const title = 'Error Title';
      const message = 'This is an error message';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: title,
            message: message,
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays error_outline icon by default', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(iconWidget.size, AppConstants.largeIconSize);
      expect(iconWidget.color, Colors.grey);
    });

    testWidgets('displays custom icon when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
            icon: Icons.warning,
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('shows retry button when onRetry is provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Error Title',
            message: 'Test error',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows back button when showBackButton is true', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
            showBackButton: true,
          ),
        ),
      );

      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows both retry and back buttons when both are enabled', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Error Title',
            message: 'Test error',
            showBackButton: true,
            onRetry: () {},
            onBack: () {},
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows custom retry button text', (WidgetTester tester) async {
      const customRetryText = 'Try Again';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
            onRetry: () {},
            retryButtonText: customRetryText,
          ),
        ),
      );

      expect(find.text(customRetryText), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('calls onRetry callback when retry button is tapped', (WidgetTester tester) async {
      bool retryCallbackCalled = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
            onRetry: () {
              retryCallbackCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCallbackCalled, isTrue);
    });

    testWidgets('calls onBack callback when back button is tapped', (WidgetTester tester) async {
      bool backCallbackCalled = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
            showBackButton: true,
            onBack: () {
              backCallbackCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Go Back'));
      await tester.pump();

      expect(backCallbackCalled, isTrue);
    });

    testWidgets('hides buttons when neither onRetry nor showBackButton is provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Test Title',
            message: 'Test Message',
          ),
        ),
      );

      expect(find.text('Retry'), findsNothing);
      expect(find.text('Go Back'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('has correct text styling', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Error Title',
            message: 'Error Message',
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Error Title'));
      final messageWidget = tester.widget<Text>(find.text('Error Message'));

      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, Colors.grey);
      expect(titleWidget.textAlign, TextAlign.center);

      expect(messageWidget.style?.color, Colors.grey);
      expect(messageWidget.textAlign, TextAlign.center);
    });

    testWidgets('is properly centered and padded', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Error Title',
            message: 'Test error',
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);

      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final mainPaddingWidget = paddingWidgets.firstWhere(
        (p) => p.padding == AppConstants.pagePadding,
        orElse: () => throw TestFailure('No Padding widget found with AppConstants.pagePadding'),
      );
      expect(mainPaddingWidget.padding, AppConstants.pagePadding);

      final columnWidget = tester.widget<Column>(find.byType(Column));
      expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('handles long error messages gracefully', (WidgetTester tester) async {
      const longMessage = 'This is a very long error message that should wrap properly '
                         'and not cause any layout issues. It contains multiple sentences '
                         'and should remain readable even when very long.';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const ErrorDisplayWidget(
            title: 'Long Message Test',
            message: longMessage,
          ),
        ),
      );

      expect(find.text('Long Message Test'), findsOneWidget);
      expect(find.text(longMessage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('button row layout is correct when both buttons are shown', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: ErrorDisplayWidget(
            title: 'Error Title',
            message: 'Test error',
            showBackButton: true,
            onRetry: () {},
            onBack: () {},
          ),
        ),
      );

      // Find the row containing buttons
      final rowWidgets = tester.widgetList<Row>(find.byType(Row));
      final buttonRow = rowWidgets.firstWhere((row) => 
        row.mainAxisAlignment == MainAxisAlignment.center);
      expect(buttonRow.mainAxisAlignment, MainAxisAlignment.center);

      // Verify both buttons are present
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}