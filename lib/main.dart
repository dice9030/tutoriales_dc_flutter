import 'package:app_project_dc/page/home_page.dart';
import 'package:app_project_dc/router/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      // home: MainBounceTabar(),
      initialRoute: 'HomePage',
      routes: appRoutes,
    );
  }
}
