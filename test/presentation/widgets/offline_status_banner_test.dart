import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_status_banner.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('OfflineStatusBanner', () {
    testWidgets('displays correct offline message', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      expect(find.text('You are offline'), findsOneWidget);
    });

    testWidgets('displays custom message', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'No internet connection'),
        ),
      );

      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('displays wifi_off icon by default', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('displays custom icon when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'Error occurred',
            icon: Icons.error,
          ),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsNothing);
    });

    testWidgets('has default orange background color', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, Colors.orange.shade100);
    });

    testWidgets('uses custom background color when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'You are offline',
            backgroundColor: Colors.red,
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('has correct default padding and margin', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.padding, const EdgeInsets.all(12));
      expect(containerWidget.margin, const EdgeInsets.all(8));
    });

    testWidgets('uses custom padding when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'You are offline',
            padding: EdgeInsets.all(16),
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.padding, const EdgeInsets.all(16));
    });

    testWidgets('uses custom margin when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'You are offline',
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.margin, const EdgeInsets.symmetric(horizontal: 16));
    });

    testWidgets('has correct layout structure', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsAtLeastNWidgets(1));
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);

      final rowWidget = tester.widget<Row>(find.byType(Row));
      expect(rowWidget.children.length, 3); // Icon, SizedBox, Expanded(Text)
    });

    testWidgets('has correct spacing between icon and text', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final spacingSizedBox = sizedBoxes.firstWhere(
        (box) => box.width == 8.0,
        orElse: () => throw TestFailure('No SizedBox with width 8.0 found.'),
      );
      expect(spacingSizedBox.width, 8.0);
    });

    testWidgets('displays with custom colors', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'Custom styled banner',
            backgroundColor: Colors.blue,
            textColor: Colors.yellow,
            iconColor: Colors.green,
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);

      final textWidget = tester.widget<Text>(find.text('Custom styled banner'));
      expect(textWidget.style?.color, Colors.yellow);

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.wifi_off));
      expect(iconWidget.color, Colors.green);
    });

    testWidgets('renders correctly in different screen sizes', (WidgetTester tester) async {
      // Test with small screen
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);

      // Test with large screen
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pumpAndSettle();

      expect(find.text('You are offline'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);

      // Reset to default
      addTearDown(tester.view.reset);
    });

    testWidgets('is accessible', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      // Test that text is readable by screen readers
      expect(find.text('You are offline'), findsOneWidget);
      
      // Test semantic structure
      final textWidget = tester.widget<Text>(find.text('You are offline'));
      expect(textWidget.semanticsLabel, isNull); // Uses default text
    });

    testWidgets('maintains visual hierarchy', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: 'You are offline'),
        ),
      );

      // Icon should be before text in the row
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children[0], isA<Icon>());
      expect(row.children[1], isA<SizedBox>());
      expect(row.children[2], isA<Expanded>());
    });

    testWidgets('handles border color when provided', (WidgetTester tester) async {
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(
            message: 'You are offline',
            borderColor: Colors.black,
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
    });

    testWidgets('handles long messages properly', (WidgetTester tester) async {
      const longMessage = 'This is a very long offline message that should wrap properly';
      
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestApp(
          child: const OfflineStatusBanner(message: longMessage),
        ),
      );

      expect(find.text(longMessage), findsOneWidget);
      
      // Verify text widget handles overflow
      final textWidget = tester.widget<Text>(find.text(longMessage));
      expect(textWidget.overflow, isNull); // Uses default handling
    });
  });
}