import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:running/home.dart';

class HomeScreen extends StatefulWidget {
  static final String homeRoute = "/home";
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("123123123"),
          onPressed: () async {
            final location = Location();
            final hasPermissions = await location.hasPermission();
            if (hasPermissions != PermissionStatus.granted) {
              await location.requestPermission();
            }

            Navigator.of(context).pushNamed(MapScreen.mapScreen);
          },
        ),
      ),
    );
  }
}
