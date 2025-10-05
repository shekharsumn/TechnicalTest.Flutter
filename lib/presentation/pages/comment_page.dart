import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/domain/usecases/get_comments_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_error_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/no_data_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/comments_list.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import '../../l10n/app_localizations.dart';
import 'package:dart_either/dart_either.dart';

/// Comments Page - Orchestrates the display of comments for a post
/// Following Single Responsibility Principle - focuses on page state management
class CommentsPage extends ConsumerWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getCommentsUseCase = ref.read(getCommentsUseCaseProvider);
    final isConnected = ref.watch(isConnectedProvider);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final postId = args?['postId'] ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: !isConnected
          ? OfflineErrorWidgets.comments(
              onGoBack: () => Navigator.of(context).pop(),
            )
          : _buildCommentsContent(context, getCommentsUseCase, postId),
    );
  }

  /// Builds the main comments content with loading and error handling
  Widget _buildCommentsContent(
    BuildContext context, 
    GetCommentsUseCase getCommentsUseCase, 
    int postId,
  ) {
    return FutureBuilder<Either<ApiError, List<CommentModel>>>(
      future: getCommentsUseCase.call(postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return const NoDataWidget();
        }

        final either = snapshot.data!;
        return either.fold(
          ifLeft: (ApiError error) {
            return ErrorDisplayWidget(
              title: AppLocalizations.of(context)!.errorLoadingComments,
              message: error.message,
              showBackButton: true,
            );
          },
          ifRight: (List<CommentModel> comments) {
            return CommentsList(comments: comments);
          },
        );
      },
    );
  }
}