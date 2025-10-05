import 'package:flutter/material.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';

/// Base class for offline error widgets
/// Following Single Responsibility Principle - only handles basic offline error display
class BaseOfflineErrorWidget extends StatelessWidget {
  const BaseOfflineErrorWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onRetry,
    this.retryButtonText = 'Go Back',
    this.showRetryButton = true,
    this.icon = Icons.wifi_off,
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
  
  /// Icon to display
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
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