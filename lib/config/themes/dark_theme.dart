import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* class DarkTheme { */
/* static ThemeData theme = ThemeData( */
/* brightness: Brightness.dark, */
/* primarySwatch: Colors.pink, */
/* textTheme: TextTheme( */
/* headline6: TextStyle( */
/* color: Colors.black, */
/* ), */
/* subtitle1: TextStyle( */
/* color: Colors.black87, */
/* ), */
/* ), */
/* ); */
/* } */

class DarkTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    primaryColor: Colors.pink,
    iconTheme: IconThemeData(
      color: Colors.pink,
    ),
    buttonTheme: ButtonThemeData().copyWith(
      buttonColor: Colors.pink,
      textTheme: ButtonTextTheme.accent,
    ),
    buttonColor: Colors.pink,
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
