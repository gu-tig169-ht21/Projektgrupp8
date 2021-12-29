//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:my_first_app/card_themes.dart';
import 'package:my_first_app/firebase_implementation.dart';
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
      ChangeNotifierProvider(
        create: (context) => PlayingCardsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FirebaseImplementation(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blackjack:)',
      home: const StartPage(),
      theme: ThemeCustom.StandardTheme,
      darkTheme: ThemeCustom.DarkTheme,
      themeMode: Provider.of<ChangeTheme>(context, listen: true).getThemeMode,
    );
  }
}
