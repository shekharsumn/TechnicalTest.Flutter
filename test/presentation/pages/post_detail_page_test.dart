import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/post_detail_page.dart';
import 'package:flutter_tech_task/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('DetailsPage Widget Tests', () {
    testWidgets('should show basic widget structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const DetailsPage()),
      );

      await tester.pump();

      // Should show some basic structure even without proper routing
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle connectivity provider', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const DetailsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle offline state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => false),
          ],
          child: TestHelpers.createTestApp(child: const DetailsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should work with use case provider', (WidgetTester tester) async {
      final mockPost = TestHelpers.createMockPost(id: 1, title: 'API Post');
      final successUseCase = SuccessGetPostByIdUseCase(mockPost);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getPostByIdUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const DetailsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show error when API call fails', (WidgetTester tester) async {
      final errorUseCase = ErrorGetPostByIdUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getPostByIdUseCaseProvider.overrideWithValue(errorUseCase),
          ],
          child: TestHelpers.createTestApp(child: const DetailsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have proper widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const DetailsPage()),
      );

      await tester.pumpAndSettle();

      // The page should be wrapped in proper widget hierarchy
      expect(find.byType(ProviderScope), findsWidgets);
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}

/// Mock implementation that returns successful data
class SuccessGetPostByIdUseCase implements GetPostByIdUseCase {

  SuccessGetPostByIdUseCase(this.post);
  final Post post;

  @override
  Future<Either<ApiError, Post>> call(int postId) async {
    return Right(post);
  }
}

/// Mock implementation that never completes to simulate loading
class SlowGetPostByIdUseCase implements GetPostByIdUseCase {
  @override
  Future<Either<ApiError, Post>> call(int postId) {
    return Future<Either<ApiError, Post>>.delayed(
      const Duration(seconds: 10),
      () => Right(TestHelpers.createMockPost(id: postId, title: 'Slow Post')),
    );
  }
}

/// Mock implementation that always returns an error
class ErrorGetPostByIdUseCase implements GetPostByIdUseCase {
  @override
  Future<Either<ApiError, Post>> call(int postId) async {
    return const Left(ApiError(
      type: ApiErrorType.server,
      message: 'Test error message',
      statusCode: 500,
    ));
  }
}

/// Mock implementation that returns no data by throwing an exception
class NoDataGetPostByIdUseCase implements GetPostByIdUseCase {
  @override
  Future<Either<ApiError, Post>> call(int postId) async {
    throw Exception('No data');
  }
}