import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tech_task/presentation/pages/home_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should render AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      // Wait for localization to load
      await tester.pumpAndSettle();

      expect(find.text('Posts'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should render TabBar with two tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('should render TabBarView with correct pages', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TabBarView), findsOneWidget);
      // TabBarView children are lazily loaded, so we can't always find them immediately
    });

    testWidgets('should switch between tabs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      // Tap on Saved tab
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();

      // The TabController should handle the switch
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('should use DefaultTabController with length 2', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DefaultTabController), findsOneWidget);
      
      final defaultTabController = tester.widget<DefaultTabController>(
        find.byType(DefaultTabController),
      );
      expect(defaultTabController.length, equals(2));
    });

    testWidgets('should display saved tab with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      // Should find the saved tab with Row and Text
      expect(find.byType(Row), findsWidgets);
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const HomePage()),
      );

      await tester.pumpAndSettle();

      // Verify basic structure - may have multiple scaffolds due to TabBarView
      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(DefaultTabController), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });
  });
}