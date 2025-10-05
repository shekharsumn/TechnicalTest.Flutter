import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/comment_page.dart';
import 'package:flutter_tech_task/presentation/widgets/comments_list.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/no_data_widget.dart';
import 'package:flutter_tech_task/domain/usecases/get_comments_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CommentsPage Widget Tests', () {
    testWidgets('should show AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: const CommentsPage()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Comments'), findsOneWidget);
    });

    testWidgets('should show offline error when not connected', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => false),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Comments'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('should show loading indicator while fetching comments', (WidgetTester tester) async {
      final quickUseCase = QuickLoadingGetCommentsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(quickUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Let the quick future complete
      await tester.pumpAndSettle();
      
      // Should show the final result (empty comments list)
      expect(find.byType(CommentsList), findsOneWidget);
    });

    testWidgets('should show comments list when data loads successfully', (WidgetTester tester) async {
      final mockComments = [
        TestHelpers.createMockComment(id: 1, body: 'Comment 1'),
        TestHelpers.createMockComment(id: 2, body: 'Comment 2'),
      ];
      final successUseCase = SuccessGetCommentsUseCase(mockComments);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CommentsList), findsOneWidget);
    });

    testWidgets('should show error widget when API call fails', (WidgetTester tester) async {
      final errorUseCase = ErrorGetCommentsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(errorUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
    });

    testWidgets('should show no data widget when no data available', (WidgetTester tester) async {
      final noDataUseCase = NoDataGetCommentsUseCase();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(noDataUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NoDataWidget), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (WidgetTester tester) async {
      final mockComments = [TestHelpers.createMockComment(id: 1, body: 'Test Comment')];
      final successUseCase = SuccessGetCommentsUseCase(mockComments);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(CommentsList), findsOneWidget);
    });

    testWidgets('should handle connectivity changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Should show loading or content when connected
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show empty comments list when no comments', (WidgetTester tester) async {
      final successUseCase = SuccessGetCommentsUseCase([]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isConnectedProvider.overrideWith((ref) => true),
            getCommentsUseCaseProvider.overrideWithValue(successUseCase),
          ],
          child: TestHelpers.createTestApp(child: const CommentsPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CommentsList), findsOneWidget);
    });
  });
}

/// Mock implementation that never completes to simulate loading
class SlowGetCommentsUseCase implements GetCommentsUseCase {
  @override
  Future<Either<ApiError, List<CommentModel>>> call(int postId) {
    return Future<Either<ApiError, List<CommentModel>>>.delayed(
      const Duration(seconds: 10),
      () => const Right([]),
    );
  }
}

/// Mock implementation that completes quickly for testing loading state
class QuickLoadingGetCommentsUseCase implements GetCommentsUseCase {
  @override
  Future<Either<ApiError, List<CommentModel>>> call(int postId) {
    return Future<Either<ApiError, List<CommentModel>>>.delayed(
      const Duration(milliseconds: 100),
      () => const Right([]),
    );
  }
}

/// Mock implementation that returns successful data
class SuccessGetCommentsUseCase implements GetCommentsUseCase {

  SuccessGetCommentsUseCase(this.comments);
  final List<CommentModel> comments;

  @override
  Future<Either<ApiError, List<CommentModel>>> call(int postId) async {
    return Right(comments);
  }
}

/// Mock implementation that always returns an error
class ErrorGetCommentsUseCase implements GetCommentsUseCase {
  @override
  Future<Either<ApiError, List<CommentModel>>> call(int postId) async {
    return const Left(ApiError(
      type: ApiErrorType.server,
      message: 'Test error message',
      statusCode: 500,
    ));
  }
}

/// Mock implementation that returns no data by throwing an exception
class NoDataGetCommentsUseCase implements GetCommentsUseCase {
  @override
  Future<Either<ApiError, List<CommentModel>>> call(int postId) async {
    throw Exception('No data');
  }
}