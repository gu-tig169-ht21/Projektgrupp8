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
      body: Stack(
        children: [
          // _image(),
          _title(),
          _playButton(),
          _howToPlayButton(),
          _statisticsButton(),
          _settingsIcon(),
        ],
      ),
    );
  }

  //Widget för bakgrundsbilden
  // Widget _image() {
  //   return Stack(
  //     children: const [
  //       Image(
  //         image: AssetImage('assets/bakgrundBlackjack.jpg'),
  //         fit: BoxFit.cover,
  //       ),
  //     ],
  //   );
  // }

  //widget för huvudtitel
  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Blackjack',
          style: TextStyle(fontSize: 50),
        ),
      ],
    );
  }

//Widget för play knapp
  Widget _playButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 280,
          left: 150,
          right: 150,
          child: ElevatedButton(
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
        ),
      ],
    );
  }

  //Widget för hjälp/how to play knapp
  Widget _howToPlayButton() {
    return Stack(children: [
      Positioned(
        bottom: 240,
        left: 100,
        right: 100,
        child: ElevatedButton(
          child: const Text('HOW TO PLAY'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpPage(),
              ),
            );
          },
        ),
      ),
    ]);
  }

  //Widget för statistik knapp
  Widget _statisticsButton() {
    return Stack(children: [
      Positioned(
        bottom: 200,
        left: 100,
        right: 100,
        child: ElevatedButton(
          child: const Text('STATISTICS'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpPage(),
              ),
            );
          },
        ),
      ),
    ]);
  }

  //widget för inställningsikon
  Widget _settingsIcon() {
    return Stack(
      children: [
        Positioned(
          bottom: 50,
          right: 50,
          child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpPage(),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
