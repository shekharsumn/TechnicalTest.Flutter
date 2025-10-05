import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/presentation/widgets/comment_card.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../l10n/app_localizations.dart';

/// A widget that displays a list of comments or an empty state
/// Following Single Responsibility Principle - only handles comments list display
class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
    required this.comments,
  }) : super(key: key);

  final List<CommentModel> comments;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: AppConstants.listPadding,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentCard(comment: comments[index]);
      },
    );
  }

  /// Builds the empty state when no comments are available
  Widget _buildEmptyState(BuildContext context) {
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
            AppLocalizations.of(context)!.noCommentsAvailable,
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
}