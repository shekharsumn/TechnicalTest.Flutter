import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/widgets/base_offline_error_widget.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// A flexible error widget that can handle both online and offline API errors
/// Following Single Responsibility Principle - only handles API error states
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
      return BaseOfflineErrorWidget(
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