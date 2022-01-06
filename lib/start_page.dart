
import 'package:my_first_app/card_customization.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:my_first_app/game_page.dart';
import 'package:my_first_app/profile_information_page.dart';
import 'package:my_first_app/settings_page.dart';
import 'package:my_first_app/statistics.dart';
import 'package:provider/provider.dart';
import 'how_to_play.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _image(),
          _container(),
          _title(),
          _playButton(),
          _howToPlayButton(),
          _statisticsButton(),
          _settingsIcon(),
          _userIcon(),
        ],
      ),
    );
  }

  //Widget för bakgrundsbilden
  Widget _image() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 1,
      child: const Image(
        image: AssetImage('assets/BackgroundForStartpage.jpg'),
        fit: BoxFit.fill,
      ),
    );
  }

//Widget för att fadea bilden
  Widget _container() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 1,
      color: Colors.white30,
    );
  }

  //widget för huvudtitel
  Widget _title() {
    return const Align(
      alignment: Alignment(0, -0.8),
      child: Text('Blackjack', style: TextStyle(fontSize: 70)
          //Tema filen?
          ),
    );
  }

//Widget för play knapp
  Widget _playButton() {
    return Align(
        alignment: const Alignment(0, -0.3),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.1,
          child: ElevatedButton(
            child: const Text('PLAY NOW'),
            onPressed: () {
              Provider.of<FirestoreImplementation>(context, listen: false)
                  .createNewUsrStat(
                      userId: Provider.of<FirebaseAuthImplementation>(context,
                              listen: false)
                          .getUserId()!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GamePage(),
                ),
              );
            },
          ),
        ));
  }

  //Widget för hjälp/how to play knapp
  Widget _howToPlayButton() {
    return Align(
        alignment: const Alignment(0, 0.10),
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.1,
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
        ));
  }

  //Widget för statistik knapp
  Widget _statisticsButton() {
    return Align(
        alignment: const Alignment(0, 0.5),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.1,
          child: ElevatedButton(
            child: const Text('STATISTICS'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Statistics(),
                ),
              );
            },
          ),
        ));
  }

  //widget för inställningsikon
  Widget _settingsIcon() {
    return Align(
      alignment: const Alignment(1.5, 0.89),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.1,
        child: IconButton(
          icon: const Icon(Icons.settings),
          iconSize: 50,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Settings(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _userIcon() {
    return Align(
        alignment: const Alignment(-1.5, 0.89),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.1,
          child: IconButton(
            icon: const Icon(Icons.portrait_rounded),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileInformation()));
            },
          ),
        ));
  }
}
