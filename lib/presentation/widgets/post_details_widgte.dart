import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/l10n/app_localizations.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// Separate widget for displaying post details
class PostDetails extends StatelessWidget {
  const PostDetails({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppConstants.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: AppConstants.tinyVerticalSpacing),
          Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppConstants.standardVerticalSpacing),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  'comments/',
                  arguments: {'postId': post.id},
                );
              },
              icon: const Icon(Icons.comment),
              label: Text(AppLocalizations.of(context)!.viewComments),
              style: ElevatedButton.styleFrom(
                padding: AppConstants.buttonPadding,
              ),
            ),
          ),
        ],
      ),
    );
  }
}