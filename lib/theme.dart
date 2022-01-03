// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

//klass som gör ett Standard tema på scaffold & appbar
class ThemeCustom {
  static ThemeData get StandardTheme {
    return ThemeData(
      primaryColor: Colors.green.shade800,
      scaffoldBackgroundColor: Colors.white,
      // fontFamily: 'Times new roman',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          primary: Colors.green[800],
          textStyle: const TextStyle(fontSize: 25),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Times new roman',
          fontSize: 20,
        ),
      ),
    );
  }

//funktion som gör ett mörkt tema på scaffold & appbar
  static ThemeData get DarkTheme {
    return ThemeData(
        primaryColor: Colors.grey[600],
        scaffoldBackgroundColor: Colors.grey[600],
        fontFamily: 'Times new roman',
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                primary: Colors.grey[800],
                textStyle: const TextStyle(fontSize: 25))),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800],
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'Times new roman',
            fontSize: 20,
          ),
        ));
  }

//funktion som gör ett ljust tema på scaffold & appbar
  static ThemeData get LightTheme {
    return ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Times new roman',
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.green[200],
              textStyle: const TextStyle(fontSize: 25))),
      appBarTheme: const AppBarTheme(
        color: Colors.grey,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Times new roman',
          fontSize: 20,
        ),
      ),
    );
  }
}
