import 'package:flutter/material.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../l10n/app_localizations.dart';

/// A reusable widget for displaying 'no data available' states consistently across the app
/// Eliminates duplicate no-data UI patterns and ensures consistent presentation
class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,
    this.title,
    this.message,
    this.icon = Icons.info_outline,
    this.onRetry,
    this.retryButtonText,
    this.showBackButton = false,
    this.onBack,
  }) : super(key: key);

  /// The main title (if null, uses localized 'No data available')
  final String? title;
  
  /// The detailed message (optional)
  final String? message;
  
  /// The icon to display (defaults to info_outline)
  final IconData icon;
  
  /// Optional retry callback
  final VoidCallback? onRetry;
  
  /// Text for the retry button (if null, uses localized 'Retry')
  final String? retryButtonText;
  
  /// Whether to show a back button
  final bool showBackButton;
  
  /// Optional back callback
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final effectiveTitle = title ?? localizations.noDataAvailable;
    final effectiveRetryText = retryButtonText ?? localizations.retry;

    return Center(
      child: Padding(
        padding: AppConstants.pagePadding,
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
              effectiveTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppConstants.smallVerticalSpacing),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
            if (onRetry != null || showBackButton) ...[
              const SizedBox(height: AppConstants.standardVerticalSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBackButton) ...[
                    ElevatedButton.icon(
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(localizations.goBack),
                    ),
                    if (onRetry != null) const SizedBox(width: AppConstants.mediumVerticalSpacing),
                  ],
                  if (onRetry != null)
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(effectiveRetryText),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}