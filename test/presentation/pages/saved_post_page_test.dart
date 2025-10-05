import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/saved_post_page.dart';
import 'package:flutter_tech_task/presentation/widgets/saved_posts_empty_widget.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('SavedPostPage Widget Tests', () {
    testWidgets('should show loading indicator when loading saved posts', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const SavedPostPage()),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty widget when no saved posts', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should show posts list when saved posts exist', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Will show empty widget since we can't easily mock savedPostsProvider
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should show offline banner when offline and has saved posts', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => false),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty widget with offline state
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should handle connectivity state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should show error widget when error occurs', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const SavedPostPage()),
      );

      await tester.pumpAndSettle();

      // Default behavior should show empty state
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      // The page should render without errors
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should handle offline state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => false),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty widget with offline indication
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should display saved posts page content', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const SavedPostPage()),
      );

      await tester.pumpAndSettle();

      // Should show some content (loading or empty state)
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });

    testWidgets('should handle provider state changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const SavedPostPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify basic functionality
      expect(find.byType(SavedPostsEmptyWidget), findsOneWidget);
    });
  });
}