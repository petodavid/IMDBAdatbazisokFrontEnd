import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      title: 'IMDB Adatbazisok',
      home: HomeScreen(),
    );
  }
}
