import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/base_offline_error_widget.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('BaseOfflineErrorWidget', () {
    testWidgets('displays title and subtitle correctly', (WidgetTester tester) async {
      const title = 'No Internet Connection';
      const subtitle = 'Please check your internet connection and try again';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: title,
            subtitle: subtitle,
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('displays wifi_off icon by default', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.wifi_off));
      expect(iconWidget.size, AppConstants.largeIconSize);
      expect(iconWidget.color, Colors.grey);
    });

    testWidgets('displays custom icon when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            icon: Icons.error_outline,
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsNothing);
    });

    testWidgets('shows retry button by default with Go Back text', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'No internet connection',
            subtitle: 'Please check your connection and try again',
          ),
        ),
      );

      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows custom retry button text when provided', (WidgetTester tester) async {
      const customButtonText = 'Try Again';
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            retryButtonText: customButtonText,
          ),
        ),
      );

      expect(find.text(customButtonText), findsOneWidget);
      expect(find.text('Go Back'), findsNothing);
    });

    testWidgets('hides retry button when showRetryButton is false', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
            showRetryButton: false,
          ),
        ),
      );

      expect(find.text('Go Back'), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('calls onRetry callback when button is tapped', (WidgetTester tester) async {
      bool callbackPressed = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: BaseOfflineErrorWidget(
            title: 'No internet connection',
            subtitle: 'Please check your connection and try again',
            onRetry: () => callbackPressed = true,
          ),
        ),
      );

      // Find button by text instead of type
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      expect(callbackPressed, isTrue);
    });

    testWidgets('calls onRetry callback with custom button text', (WidgetTester tester) async {
      bool callbackPressed = false;
      const customButtonText = 'Retry Connection';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: BaseOfflineErrorWidget(
            title: 'No internet connection',
            subtitle: 'Please check your connection and try again',
            retryButtonText: customButtonText,
            onRetry: () => callbackPressed = true,
          ),
        ),
      );

      await tester.tap(find.text(customButtonText));
      await tester.pumpAndSettle();

      expect(callbackPressed, isTrue);
    });

    testWidgets('has correct text styles for title and subtitle', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'Test Title',
            subtitle: 'Test Subtitle',
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('Test Title'));
      final subtitleWidget = tester.widget<Text>(find.text('Test Subtitle'));

      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, Colors.grey);
      expect(titleWidget.textAlign, TextAlign.center);

      expect(subtitleWidget.style?.color, Colors.grey);
      expect(subtitleWidget.textAlign, TextAlign.center);
    });

    testWidgets('is centered on screen', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const BaseOfflineErrorWidget(
            title: 'No internet connection',
            subtitle: 'Please check your connection and try again',
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);

      final columnWidget = tester.widget<Column>(find.byType(Column));
      expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);
    });
  });
}