import 'package:flutter/material.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// Widget for saved posts page when empty (handles both online and offline states)
/// Following Single Responsibility Principle - only handles saved posts empty state
class SavedPostsEmptyWidget extends StatelessWidget {
  const SavedPostsEmptyWidget({
    Key? key,
    required this.isConnected,
  }) : super(key: key);

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isConnected ? Icons.bookmark_border : Icons.wifi_off,
            size: AppConstants.largeIconSize,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.mediumVerticalSpacing),
          Text(
            isConnected 
              ? 'No saved posts' 
              : 'No internet connection\nSaved posts will appear here when you save them',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          if (!isConnected) ...[
            const SizedBox(height: AppConstants.smallVerticalSpacing),
            Text(
              'Connect to internet to load new posts',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}