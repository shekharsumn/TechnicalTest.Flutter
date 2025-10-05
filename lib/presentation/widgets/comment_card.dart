import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/comment_model.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// A reusable widget for displaying a single comment
/// Following Single Responsibility Principle - only handles comment display
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
            _buildCommentHeader(context),
            const SizedBox(height: AppConstants.authorBodySpacing),
            _buildCommentBody(context),
          ],
        ),
      ),
    );
  }

  /// Builds the comment header with avatar and user info
  Widget _buildCommentHeader(BuildContext context) {
    return Row(
      children: [
        _buildUserAvatar(context),
        const SizedBox(width: AppConstants.avatarTextSpacing),
        Expanded(
          child: _buildUserInfo(context),
        ),
      ],
    );
  }

  /// Builds the user avatar with initial
  Widget _buildUserAvatar(BuildContext context) {
    return CircleAvatar(
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
    );
  }

  /// Builds the user name and email info
  Widget _buildUserInfo(BuildContext context) {
    return Column(
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
    );
  }

  /// Builds the comment body text
  Widget _buildCommentBody(BuildContext context) {
    return Text(
      comment.body,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        height: AppConstants.commentBodyLineHeight,
      ),
    );
  }
}