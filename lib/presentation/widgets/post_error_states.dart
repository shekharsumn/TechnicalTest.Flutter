import 'package:flutter/material.dart';
import 'package:flutter_tech_task/presentation/widgets/error_display_widget.dart';
import 'package:flutter_tech_task/presentation/widgets/no_data_widget.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:flutter_tech_task/utils/app_constants.dart';
import '../../l10n/app_localizations.dart';

/// A widget that handles different error states for post detail page
/// Following Single Responsibility Principle - only handles error display logic
class PostErrorStates {
  PostErrorStates._();

  /// Error state when saved posts fail to load
  static Widget savedPostsLoadingError(
    BuildContext context, 
    Object error,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.postDetails)),
      body: Center(
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
              AppLocalizations.of(context)!.errorLoadingSavedPosts(error.toString()),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Loading state scaffold
  static Widget loading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.postDetails)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  /// No data available state
  static Widget noData(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post details')),
      body: const NoDataWidget(),
    );
  }

  /// API error state when fetching post fails
  static Widget apiError(BuildContext context, ApiError error) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post details')),
      body: ErrorDisplayWidget(
        title: 'Error Loading Post',
        message: error.message,
        showBackButton: true,
      ),
    );
  }
}