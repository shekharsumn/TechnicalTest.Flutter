import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/post_list_page.dart';
import 'package:flutter_tech_task/presentation/widgets/post_list_item.dart';
import 'package:flutter_tech_task/presentation/widgets/api_error_widget.dart';
import 'package:flutter_tech_task/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('PostListPage Widget Tests', () {
    testWidgets('should show loading indicator while data is loading', (WidgetTester tester) async {
      // Create a use case that completes quickly to avoid timer issues
      final mockUseCase = QuickLoadingGetPostsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(mockUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Let the future complete
      await tester.pumpAndSettle();
      
      // Should show the final result
      expect(find.text('No posts available'), findsOneWidget);
    });

    testWidgets('should show error widget when API call fails', (WidgetTester tester) async {
      final errorUseCase = ErrorGetPostsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(errorUseCase),
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ApiErrorWidget), findsOneWidget);
    });

    testWidgets('should show posts list when data loads successfully', (WidgetTester tester) async {
      final mockPosts = [
        TestHelpers.createMockPost(id: 1, title: 'Test Post 1'),
        TestHelpers.createMockPost(id: 2, title: 'Test Post 2'),
      ];
      
      final successUseCase = SuccessGetPostsUseCase(mockPosts);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PostListItem), findsNWidgets(2));
    });

    testWidgets('should show no posts message when list is empty', (WidgetTester tester) async {
      final successUseCase = SuccessGetPostsUseCase([]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No posts available'), findsOneWidget);
    });

    testWidgets('should show no posts message when snapshot has no data', (WidgetTester tester) async {
      final noDataUseCase = NoDataGetPostsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(noDataUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No posts available'), findsOneWidget);
    });

    testWidgets('should have correct widget structure', (WidgetTester tester) async {
      final mockPosts = [TestHelpers.createMockPost(id: 1, title: 'Test Post')];
      final successUseCase = SuccessGetPostsUseCase(mockPosts);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should use PageStorageKey for ListView', (WidgetTester tester) async {
      final mockPosts = [TestHelpers.createMockPost(id: 1, title: 'Test Post')];
      final successUseCase = SuccessGetPostsUseCase(mockPosts);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.key, isA<PageStorageKey<String>>());
      final key = listView.key as PageStorageKey<String>;
      expect(key.value, equals('post-list'));
    });

    testWidgets('should retry when retry button is pressed', (WidgetTester tester) async {
      final retryUseCase = RetryGetPostsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getPostsUseCaseProvider.overrideWithValue(retryUseCase),
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const ListPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Should show error initially
      expect(find.byType(ApiErrorWidget), findsOneWidget);
      
      // Find retry button and tap it
      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);
      
      await tester.tap(retryButton);
      await tester.pumpAndSettle();

      // Verify retry was called
      expect(retryUseCase.callCount, equals(2)); // Initial call + retry
    });
  });
}

/// Mock implementation that never completes to simulate loading
class SlowGetPostsUseCase implements GetPostsUseCase {
  @override
  Future<Either<ApiError, List<Post>>> call() {
    return Future<Either<ApiError, List<Post>>>.delayed(
      const Duration(seconds: 10),
      () => const Right([]),
    );
  }
}

/// Mock implementation that completes quickly for testing loading state
class QuickLoadingGetPostsUseCase implements GetPostsUseCase {
  @override
  Future<Either<ApiError, List<Post>>> call() {
    return Future<Either<ApiError, List<Post>>>.delayed(
      const Duration(milliseconds: 100),
      () => const Right([]),
    );
  }
}

/// Mock implementation that always returns an error
class ErrorGetPostsUseCase implements GetPostsUseCase {
  @override
  Future<Either<ApiError, List<Post>>> call() async {
    return const Left(ApiError(
      type: ApiErrorType.server,
      message: 'Test error message',
      statusCode: 500,
    ));
  }
}

/// Mock implementation that returns successful data
class SuccessGetPostsUseCase implements GetPostsUseCase {

  SuccessGetPostsUseCase(this.posts);
  final List<Post> posts;

  @override
  Future<Either<ApiError, List<Post>>> call() async {
    return Right(posts);
  }
}

/// Mock implementation that returns null data by throwing an exception
class NoDataGetPostsUseCase implements GetPostsUseCase {
  @override
  Future<Either<ApiError, List<Post>>> call() async {
    throw Exception('No data');
  }
}

/// Mock implementation for testing retry functionality
class RetryGetPostsUseCase implements GetPostsUseCase {
  int callCount = 0;

  @override
  Future<Either<ApiError, List<Post>>> call() async {
    callCount++;
    if (callCount == 1) {
      // First call returns error
      return const Left(ApiError(
        type: ApiErrorType.network,
        message: 'Network error',
        statusCode: 500,
      ));
    } else {
      // Subsequent calls return success
      return const Right([]);
    }
  }
}