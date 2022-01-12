// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

//klass som gör ett Standard tema på scaffold & appbar
class ThemeCustom {
  static ThemeData get StandardTheme {
    return ThemeData(
       textTheme: const TextTheme(
         bodyText1: TextStyle(),
         bodyText2: TextStyle(),
         headline6: TextStyle(),
       ).apply(
         bodyColor: Colors.black,
       ),
      primaryColor: Colors.green.shade800,
      scaffoldBackgroundColor: Colors.white,
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
          color: Colors.black,
          fontSize: 20,
        ),
      ),

    );
  }

//funktion som gör ett mörkt tema på scaffold & appbar
  static ThemeData get DarkTheme {
    return ThemeData(
      primaryColor: Colors.grey,
      scaffoldBackgroundColor: Colors.grey,
      canvasColor: Colors.grey,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.blueGrey[900],
              textStyle: const TextStyle(fontSize: 25))),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      //ändrar färg på iconbuttons
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
