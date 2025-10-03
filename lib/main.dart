
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/presentation/pages/post_detail_page.dart';
import 'package:flutter_tech_task/presentation/pages/home_page.dart';
import 'package:flutter_tech_task/presentation/pages/post_list_page.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home/',
      routes: {
        'home/': (context) => const HomePage(),
        'list/': (context) => const ListPage(),
        'details/': (context) => const DetailsPage(),
      },
    );
  }
}