//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:my_first_app/how_to_play.dart';
import 'package:my_first_app/start_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HowToPlay()),
        ChangeNotifierProvider(
          create: (context) => BlackJack(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'blackjack:)',
        home: StartPage(),
      ),
    ),
  );
}
