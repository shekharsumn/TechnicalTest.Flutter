// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Tech Task';

  @override
  String get posts => 'Posts';

  @override
  String get all => 'All';

  @override
  String get saved => 'Saved';

  @override
  String get postDetails => 'Post details';

  @override
  String errorLoadingSavedPosts(String error) {
    return 'Error loading saved posts: $error';
  }

  @override
  String get offlineModeShowingSavedPost => 'Offline mode - showing saved post';

  @override
  String get offlineModeShowingSavedPostsOnly =>
      'Offline mode - showing saved posts only';

  @override
  String get retry => 'Retry';

  @override
  String get goBack => 'Go Back';

  @override
  String get comments => 'Comments';

  @override
  String get errorLoadingComments => 'Error loading comments';

  @override
  String get noCommentsAvailable => 'No comments available for this post.';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get noInternetConnectionDescription =>
      'Unable to load comments. Please check your internet connection and try again.';

  @override
  String get noSavedPosts => 'No saved posts';

  @override
  String get noInternetConnectionSavedPosts =>
      'No internet connection\nSaved posts will appear here when you save them';

  @override
  String get connectToInternetToLoadNewPosts =>
      'Connect to internet to load new posts';

  @override
  String get viewComments => 'View Comments';

  @override
  String get errorLoadingSavedPostsGeneric => 'Error Loading Saved Posts';

  @override
  String get badRequest => 'Bad request';

  @override
  String get unauthorized => 'Unauthorized';

  @override
  String get notFound => 'Not found';

  @override
  String get serverError => 'Server error';

  @override
  String get networkError => 'Network error';

  @override
  String get connectionTimeout => 'Connection timeout';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noDataAvailable => 'No data available';
}
