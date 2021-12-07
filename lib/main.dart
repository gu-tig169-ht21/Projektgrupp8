import 'package:flutter/material.dart';
import 'package:my_first_app/how_to_play.dart';
import 'package:my_first_app/start_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HowToPlay(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'blackjack:)',
        home: StartPage(),
      ),
    ),
  );
}
