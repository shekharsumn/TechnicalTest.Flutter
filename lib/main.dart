
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/comment_page.dart';
import 'presentation/pages/post_detail_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/post_list_page.dart';
import 'l10n/app_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tech Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: 'home/',
      routes: {
        'home/': (context) => const HomePage(),
        'list/': (context) => const ListPage(),
        'details/': (context) => const DetailsPage(),
        'comments/': (context) => const CommentsPage(),
      },
    );
  }
}