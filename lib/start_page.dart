import 'how_to_play.dart';
import 'package:flutter/material.dart';
import 'rules.dart';
import 'main.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(""),
                fit: BoxFit.cover,
              ),
            ),
            margin: const EdgeInsets.only(left: 20, top: 40),
          ),
          const Text(
            'Blackjack',
            style: TextStyle(fontSize: 50),
          ),
          Container(
            margin: const EdgeInsets.only(top: 125),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              maximumSize: const Size(200, 50),
            ),
            child: const Text('PLAY NOW'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpPage(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
              ),
              child: const Text('HOW TO PLAY'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpPage(),
                    ));
              }),
          Container(
            margin: const EdgeInsets.only(top: 30),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
              ),
              child: const Text('STATISTICS'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpPage(),
                    ));
              })
        ],
      ),
    );
  }
}
