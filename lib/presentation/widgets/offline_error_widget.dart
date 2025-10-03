import 'package:flutter/material.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// A reusable widget for displaying offline/no internet connection errors
/// 
/// This widget provides a consistent UI across the app for offline states,
/// including an icon, title, subtitle, and optional action button.
class OfflineErrorWidget extends StatelessWidget {
  const OfflineErrorWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onRetry,
    this.retryButtonText = 'Go Back',
    this.showRetryButton = true,
  }) : super(key: key);

  /// The main title text (e.g., "No internet connection")
  final String title;
  
  /// The subtitle/description text
  final String subtitle;
  
  /// Callback function when retry button is pressed
  final VoidCallback? onRetry;
  
  /// Text for the retry/action button
  final String retryButtonText;
  
  /// Whether to show the retry button
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: AppConstants.largeIconSize,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.mediumVerticalSpacing),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppConstants.smallVerticalSpacing),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          if (showRetryButton) ...[
            const SizedBox(height: AppConstants.mediumVerticalSpacing),
            ElevatedButton.icon(
              onPressed: onRetry ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(retryButtonText),
            ),
          ],
        ],
      ),
    );
  }
}

/// A specialized version for specific offline scenarios
class OfflineErrorWidgets {
  OfflineErrorWidgets._();

  /// Widget for when comments require internet connection
  static Widget comments({VoidCallback? onGoBack}) {
    return OfflineErrorWidget(
      title: 'No internet connection',
      subtitle: 'Comments require an internet connection.\nConnect to internet to view comments.',
      onRetry: onGoBack,
    );
  }

  /// Widget for when posts are not saved locally
  static Widget postNotSaved({VoidCallback? onGoBack}) {
    return OfflineErrorWidget(
      title: 'No internet connection',
      subtitle: 'This post is not saved locally.\nConnect to internet to view it.',
      onRetry: onGoBack,
    );
  }

  /// Widget for general API errors when offline
  static Widget general({
    required String message,
    VoidCallback? onGoBack,
  }) {
    return OfflineErrorWidget(
      title: 'No internet connection',
      subtitle: message,
      onRetry: onGoBack,
    );
  }
}

/// Widget for saved posts page when empty (handles both online and offline)
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

/// A flexible error widget that can handle both online and offline states
class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({
    Key? key,
    required this.isConnected,
    required this.error,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.showRetryButton = true,
    this.offlineSubtitle = 'Please check your internet connection and try again',
  }) : super(key: key);

  /// Whether the device is connected to internet
  final bool isConnected;
  
  /// The API error object
  final dynamic error;
  
  /// Callback function when retry button is pressed
  final VoidCallback? onRetry;
  
  /// Text for the retry button
  final String retryButtonText;
  
  /// Whether to show the retry button
  final bool showRetryButton;
  
  /// Subtitle text to show when offline
  final String offlineSubtitle;

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return OfflineErrorWidget(
        title: 'No internet connection',
        subtitle: offlineSubtitle,
        onRetry: onRetry,
        retryButtonText: retryButtonText,
        showRetryButton: showRetryButton,
      );
    }

    // Online error state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppConstants.largeIconSize,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.mediumVerticalSpacing),
          Text(
            error?.toString() ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          if (showRetryButton) ...[
            const SizedBox(height: AppConstants.mediumVerticalSpacing),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryButtonText),
            ),
          ],
        ],
      ),
    );
  }
}