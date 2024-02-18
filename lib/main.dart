import 'package:csit2023/touristplaces/HealthData.dart';
import 'package:flutter/material.dart';
import 'package:csit2023/splash_screen.dart';
import 'package:csit2023/gpstracking.dart';
import 'package:csit2023/grape.dart';
import 'package:csit2023/menu.dart';
import 'package:csit2023/login_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  LoginScreen(),
      
    );
  }
}
