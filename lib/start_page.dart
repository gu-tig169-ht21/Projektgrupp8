import 'package:my_first_app/game_page.dart';

import 'how_to_play.dart';
import 'package:flutter/material.dart';
import 'rules.dart';
import 'main.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('BLAACKJAAAACCKK'),
          TextButton(
            child: const Text('Tryck här'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GamePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
