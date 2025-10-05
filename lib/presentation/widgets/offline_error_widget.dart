import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/widgets/base_offline_error_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/specialized_offline_error_widgets.dart';

/// Legacy wrapper for backward compatibility
/// Delegates to BaseOfflineErrorWidget for actual implementation
/// Following DRY principle - avoids code duplication
class OfflineErrorWidget extends BaseOfflineErrorWidget {
  const OfflineErrorWidget({
    Key? key,
    required String title,
    required String subtitle,
    VoidCallback? onRetry,
    String retryButtonText = 'Go Back',
    bool showRetryButton = true,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          onRetry: onRetry,
          retryButtonText: retryButtonText,
          showRetryButton: showRetryButton,
        );
}

/// Legacy wrapper for specialized offline scenarios
/// Following DRY principle - delegates to new specialized widgets
class OfflineErrorWidgets {
  OfflineErrorWidgets._();

  /// Widget for when comments require internet connection
  static Widget comments({VoidCallback? onGoBack}) {
    return SpecializedOfflineErrorWidgets.comments(onGoBack: onGoBack);
  }

  /// Widget for when posts are not saved locally
  static Widget postNotSaved({VoidCallback? onGoBack}) {
    return SpecializedOfflineErrorWidgets.postNotSaved(onGoBack: onGoBack);
  }

  /// Widget for general API errors when offline
  static Widget general({
    required String message,
    VoidCallback? onGoBack,
  }) {
    return SpecializedOfflineErrorWidgets.general(
      message: message, 
      onGoBack: onGoBack,
    );
  }
}