import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.pink,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        color: Colors.black87,
      ),
    ),
  );
}
