import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/no_data_widget.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('NoDataWidget', () {
    testWidgets('displays default localized title when none provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(),
        ),
      );

      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('displays custom title when provided', (WidgetTester tester) async {
      const customTitle = 'Custom No Data Title';
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(
            title: customTitle,
          ),
        ),
      );

      expect(find.text(customTitle), findsOneWidget);
      expect(find.text('No data available'), findsNothing);
    });

    testWidgets('displays message when provided', (WidgetTester tester) async {
      const message = 'This is a custom message explaining the no data state';
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(
            message: message,
          ),
        ),
      );

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('does not display message when not provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(),
        ),
      );

      // Should only find the title text
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('displays info_outline icon by default', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(),
        ),
      );

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.info_outline));
      expect(iconWidget.size, AppConstants.largeIconSize);
      expect(iconWidget.color, Colors.grey);
    });

    testWidgets('displays custom icon when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(
            icon: Icons.folder_open,
          ),
        ),
      );

      expect(find.byIcon(Icons.folder_open), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('shows retry button when onRetry is provided', (WidgetTester tester) async {
      bool callbackCalled = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: NoDataWidget(
            onRetry: () {
              callbackCalled = true;
            },
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('shows back button when showBackButton is true', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(
            showBackButton: true,
          ),
        ),
      );

      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows custom retry button text when provided', (WidgetTester tester) async {
      const customText = 'Load Data';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: NoDataWidget(
            onRetry: () {},
            retryButtonText: customText,
          ),
        ),
      );

      expect(find.text(customText), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('calls onBack callback when back button is tapped', (WidgetTester tester) async {
      bool backCallbackCalled = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: NoDataWidget(
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

    testWidgets('shows both retry and back buttons when both are enabled', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: NoDataWidget(
            showBackButton: true,
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Go Back'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('hides buttons when none are configured', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(),
        ),
      );

      expect(find.text('Retry'), findsNothing);
      expect(find.text('Go Back'), findsNothing);
      expect(find.byIcon(Icons.refresh), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('has correct text styling', (WidgetTester tester) async {
      const message = 'Test message';
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const NoDataWidget(
            message: message,
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('No data available'));
      final messageWidget = tester.widget<Text>(find.text(message));

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
          child: const NoDataWidget(),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);

      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final mainPaddingWidget = paddingWidgets.firstWhere((p) => p.padding == AppConstants.pagePadding);
      expect(mainPaddingWidget.padding, AppConstants.pagePadding);

      final columnWidget = tester.widget<Column>(find.byType(Column));
      expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('handles all parameters together', (WidgetTester tester) async {
      bool retryCallbackCalled = false;
      bool backCallbackCalled = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: NoDataWidget(
            title: 'Custom Title',
            message: 'Custom Message',
            icon: Icons.error,
            showBackButton: true,
            onRetry: () {
              retryCallbackCalled = true;
            },
            onBack: () {
              backCallbackCalled = true;
            },
            retryButtonText: 'Try Again',
          ),
        ),
      );

      expect(find.text('Custom Title'), findsOneWidget);
      expect(find.text('Custom Message'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();
      expect(retryCallbackCalled, isTrue);

      await tester.tap(find.text('Go Back'));
      await tester.pump();
      expect(backCallbackCalled, isTrue);
    });
  });
}