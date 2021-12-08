import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

int saldo = 300;

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'New Game',
                child: Text('New Game'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'Forfeit',
                child: Text('Forfeit'),
              ),
              const PopupMenuItem<String>(
                value: 'Quit to main menu',
                child: Text('Quit to main menu'),
              ),
            ],
            onSelected: (String choice) {
              switch (choice) {
                case 'New Game':
                  {
                    //startar ett nytt spel
                    break;
                  }
                case 'Settings':
                  {
                    //ska ta dig till inställningssidan
                    break;
                  }
                case 'Forfeit':
                  {
                    //du ger upp, får tillbaka halva insatsen
                    break;
                  }
                case 'Quit to main menu':
                  {
                    //forfeitar och quittar till main
                    break;
                  }
              }
            },
          ),
        ),
        body: Column(
          children: [Row()],
        ));
  }
}
