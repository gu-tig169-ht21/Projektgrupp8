//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:my_first_app/how_to_play.dart';
import 'package:my_first_app/settings_page.dart';
import 'package:my_first_app/start_page.dart';
import 'package:my_first_app/theme.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChangeTheme()),
      ChangeNotifierProvider(create: (context) => HowToPlay()),
      ChangeNotifierProvider(
        create: (context) => BlackJack(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blackjack:)',
      home: const StartPage(),
      theme: ThemeCustom.StandardTheme,
      darkTheme: ThemeCustom.DarkTheme,
      // themeMode: Provider.of<ChangeTheme>(context, listen: false).getThemeMode, skapa en statefulwidget med en materialapp inom sig
    ),
  ));
}
