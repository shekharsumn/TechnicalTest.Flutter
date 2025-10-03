import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/domian/usecases/get_comments_usecase.dart';
import 'package:flutter_tech_task/presentation/providers/connectivity_notifier.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_error_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import 'package:dart_either/dart_either.dart';

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
          : FutureBuilder<Either<ApiError, List<CommentModel>>>(
              future: getCommentsUseCase.call(postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final either = snapshot.data!;
                return either.fold(
                  ifLeft: (ApiError error) {
                    return ErrorDisplayWidget(
                      title: 'Error Loading Comments',
                      message: error.message,
                      showBackButton: true,
                    );
                  },
                  ifRight: (List<CommentModel> comments) {
                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.comment_outlined,
                              size: AppConstants.largeIconSize,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: AppConstants.mediumVerticalSpacing),
                            Text(
                              'No comments yet',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: AppConstants.smallVerticalSpacing),
                            Text(
                              'Be the first to comment on this post!',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: AppConstants.listPadding,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return CommentCard(comment: comments[index]);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment}) : super(key: key);
  
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppConstants.commentCardMargin,
      elevation: AppConstants.commentCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.commentCardBorderRadius),
      ),
      child: Padding(
        padding: AppConstants.commentCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: AppConstants.avatarRadius,
                  child: Text(
                    comment.name.isNotEmpty 
                        ? comment.name[0].toUpperCase() 
                        : 'U',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.avatarTextSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        comment.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.authorBodySpacing),
            Text(
              comment.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: AppConstants.commentBodyLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}