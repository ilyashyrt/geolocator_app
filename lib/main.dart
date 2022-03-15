// ignore_for_file: prefer_const_constructors
import 'package:example_app/constants/routes.dart';
import 'package:example_app/screens/home_page.dart';
import 'package:example_app/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  requestPermission() async {
    await Geolocator.requestPermission();
  }
  requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRoutes.homePage : (context) =>  HomePage(),
        AppRoutes.splashPage: (context) => SplashPage(),
      },
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

