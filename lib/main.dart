import 'package:flutter/material.dart';
import 'package:running/home.dart';
import 'package:running/test.dart';
import 'package:wemapgl/wemapgl.dart' as WEMAP;

void main() {
  WEMAP.Configuration.setWeMapKey('GqfwrZUEfxbwbnQUhtBMFivEysYIxelQ');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: HomeScreen.homeRoute,
      routes: {
        HomeScreen.homeRoute: (ctx) => HomeScreen(),
        MapScreen.mapScreen: (ctx) => MapScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
