// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latin (`la`).
class AppLocalizationsLa extends AppLocalizations {
  AppLocalizationsLa([String locale = 'la']) : super(locale);

  @override
  String get appTitle => 'Opus Technicum Flutter';

  @override
  String get posts => 'Scripta';

  @override
  String get all => 'Omnia';

  @override
  String get saved => 'Servata';

  @override
  String get postDetails => 'Particularia scripti';

  @override
  String errorLoadingSavedPosts(String error) {
    return 'Error in carendo scriptis servatis: $error';
  }

  @override
  String get offlineModeShowingSavedPost =>
      'Modus sine conexu - ostendendum scriptum servatum';

  @override
  String get offlineModeShowingSavedPostsOnly =>
      'Modus sine conexu - ostendenda tantum scripta servata';

  @override
  String get retry => 'Iterare';

  @override
  String get goBack => 'Redire';

  @override
  String get comments => 'Commentaria';

  @override
  String get errorLoadingComments => 'Error in carendo commentariis';

  @override
  String get noCommentsAvailable =>
      'Nulla commentaria disponibilia pro hoc scripto.';

  @override
  String get noInternetConnection => 'Nulla conexio interretialis';

  @override
  String get noInternetConnectionDescription =>
      'Non possunt careri commentaria. Verifica conexionem interretialem et itera.';

  @override
  String get noSavedPosts => 'Nulla scripta servata';

  @override
  String get noInternetConnectionSavedPosts =>
      'Nulla conexio interretialis\nScripta servata hic apparebunt quando ea servas';

  @override
  String get connectToInternetToLoadNewPosts =>
      'Conecte ad interrete ad nova scripta carenda';

  @override
  String get viewComments => 'Videre Commentaria';

  @override
  String get errorLoadingSavedPostsGeneric =>
      'Error in carendo scriptis servatis';

  @override
  String get badRequest => 'Petitio mala';

  @override
  String get unauthorized => 'Non auctorizatus';

  @override
  String get notFound => 'Non inventum';

  @override
  String get serverError => 'Error servitoris';

  @override
  String get networkError => 'Error retis';

  @override
  String get connectionTimeout => 'Tempus conexionis exspiravit';

  @override
  String get requestCancelled => 'Petitio cancellata';

  @override
  String get somethingWentWrong => 'Aliquid male ivit';

  @override
  String get noDataAvailable => 'Nulla data disponibilia';
}
