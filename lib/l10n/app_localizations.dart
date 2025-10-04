import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_la.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('la')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Tech Task'**
  String get appTitle;

  /// Title for posts section
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// Label for all posts tab
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Label for saved posts tab
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// Title for post detail page
  ///
  /// In en, this message translates to:
  /// **'Post details'**
  String get postDetails;

  /// Error message when saved posts fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading saved posts: {error}'**
  String errorLoadingSavedPosts(String error);

  /// Message shown when displaying a saved post offline
  ///
  /// In en, this message translates to:
  /// **'Offline mode - showing saved post'**
  String get offlineModeShowingSavedPost;

  /// Message shown when displaying saved posts list offline
  ///
  /// In en, this message translates to:
  /// **'Offline mode - showing saved posts only'**
  String get offlineModeShowingSavedPostsOnly;

  /// Button text for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Button text for going back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Title for comments page
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Error title when comments fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading comments'**
  String get errorLoadingComments;

  /// Message when no comments are found
  ///
  /// In en, this message translates to:
  /// **'No comments available for this post.'**
  String get noCommentsAvailable;

  /// Error message when offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Detailed message when offline
  ///
  /// In en, this message translates to:
  /// **'Unable to load comments. Please check your internet connection and try again.'**
  String get noInternetConnectionDescription;

  /// Message when no posts are saved
  ///
  /// In en, this message translates to:
  /// **'No saved posts'**
  String get noSavedPosts;

  /// Message when offline and no saved posts
  ///
  /// In en, this message translates to:
  /// **'No internet connection\nSaved posts will appear here when you save them'**
  String get noInternetConnectionSavedPosts;

  /// Message prompting user to connect to internet
  ///
  /// In en, this message translates to:
  /// **'Connect to internet to load new posts'**
  String get connectToInternetToLoadNewPosts;

  /// Button text to view comments
  ///
  /// In en, this message translates to:
  /// **'View Comments'**
  String get viewComments;

  /// Generic error title for saved posts
  ///
  /// In en, this message translates to:
  /// **'Error Loading Saved Posts'**
  String get errorLoadingSavedPostsGeneric;

  /// HTTP 400 error message
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get badRequest;

  /// HTTP 401 error message
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// HTTP 404 error message
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// HTTP 500+ error message
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// Network connectivity error
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// Connection timeout error
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// Request cancelled error
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'la'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'la':
      return AppLocalizationsLa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
