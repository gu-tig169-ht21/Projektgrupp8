// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

//klass som gör ett Standard tema på scaffold & appbar
class ThemeCustom {
  static ThemeData get StandardTheme {
    return ThemeData(
        primaryColor: Colors.green.shade800,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Times new roman',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Times new roman',
            fontSize: 20,
          ),
        ));
  }

//klass som gör ett mörkt tema på scaffold & appbar
  static ThemeData get DarkTheme {
    return ThemeData(
        primaryColor: Colors.grey[800],
        scaffoldBackgroundColor: Colors.grey[800],
        fontFamily: 'Times new roman',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Times new roman',
            fontSize: 20,
          ),
        ));
  }

//klass som gör ett ljust tema på scaffold & appbar
  static ThemeData get LightTheme {
    return ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Times new roman',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.green[800],
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.grey,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Times new roman',
            fontSize: 20,
          ),
        ));
  }
}
