import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/widgets/base_offline_error_widget.dart';

/// Specialized offline error widgets for specific scenarios
/// Following Single Responsibility Principle - each method handles one specific error case
class SpecializedOfflineErrorWidgets {
  SpecializedOfflineErrorWidgets._();

  /// Widget for when comments require internet connection
  static Widget comments({VoidCallback? onGoBack}) {
    return BaseOfflineErrorWidget(
      title: 'No internet connection',
      subtitle: 'Comments require an internet connection.\nConnect to internet to view comments.',
      onRetry: onGoBack,
    );
  }

  /// Widget for when posts are not saved locally
  static Widget postNotSaved({VoidCallback? onGoBack}) {
    return BaseOfflineErrorWidget(
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
    return BaseOfflineErrorWidget(
      title: 'No internet connection',
      subtitle: message,
      onRetry: onGoBack,
    );
  }

  /// Widget for saved posts page when empty and offline
  static Widget savedPostsEmpty({VoidCallback? onRetry}) {
    return BaseOfflineErrorWidget(
      title: 'No internet connection',
      subtitle: 'Saved posts will appear here when you save them\nConnect to internet to load new posts',
      onRetry: onRetry,
      retryButtonText: 'Retry',
    );
  }
}