// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tarea Técnica Flutter';

  @override
  String get posts => 'Publicaciones';

  @override
  String get all => 'Todas';

  @override
  String get saved => 'Guardadas';

  @override
  String get postDetails => 'Detalles de la publicación';

  @override
  String errorLoadingSavedPosts(String error) {
    return 'Error al cargar publicaciones guardadas: $error';
  }

  @override
  String get offlineModeShowingSavedPost =>
      'Modo sin conexión - mostrando publicación guardada';

  @override
  String get offlineModeShowingSavedPostsOnly =>
      'Modo sin conexión - mostrando solo publicaciones guardadas';

  @override
  String get retry => 'Reintentar';

  @override
  String get goBack => 'Volver';

  @override
  String get comments => 'Comentarios';

  @override
  String get errorLoadingComments => 'Error al cargar comentarios';

  @override
  String get noCommentsAvailable =>
      'No hay comentarios disponibles para esta publicación.';

  @override
  String get noInternetConnection => 'Sin conexión a internet';

  @override
  String get noInternetConnectionDescription =>
      'No se pueden cargar los comentarios. Verifique su conexión a internet e inténtelo nuevamente.';

  @override
  String get noSavedPosts => 'No hay publicaciones guardadas';

  @override
  String get noInternetConnectionSavedPosts =>
      'Sin conexión a internet\nLas publicaciones guardadas aparecerán aquí cuando las guarde';

  @override
  String get connectToInternetToLoadNewPosts =>
      'Conéctese a internet para cargar nuevas publicaciones';

  @override
  String get viewComments => 'Ver Comentarios';

  @override
  String get errorLoadingSavedPostsGeneric =>
      'Error al cargar publicaciones guardadas';

  @override
  String get badRequest => 'Solicitud incorrecta';

  @override
  String get unauthorized => 'No autorizado';

  @override
  String get notFound => 'No encontrado';

  @override
  String get serverError => 'Error del servidor';

  @override
  String get networkError => 'Error de red';

  @override
  String get connectionTimeout => 'Tiempo de conexión agotado';

  @override
  String get requestCancelled => 'Solicitud cancelada';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get noDataAvailable => 'No hay datos disponibles';
}
