import 'package:my_first_app/models/card_themes.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:my_first_app/views/game_page.dart';
import 'package:my_first_app/views/profile_information_page.dart';
import 'package:my_first_app/views/settings_page.dart';
import 'package:my_first_app/views/statistics_page.dart';
import 'package:my_first_app/models/statistics_handler.dart';
import 'package:provider/provider.dart';
import 'how_to_play_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../game_engine/error_handling.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    Provider.of<CardThemeHandler>(context, listen: false).setUpCardThemes(
        context: context); //hämtar data som krävs av kortteman etc.
    setUpStatsAndBalance();
    Provider.of<CardThemeHandler>(context, listen: false)
        .fetchBalance(context: context); //hämtar ditt saldo från databasen
    super.initState();
  }

  void setUpStatsAndBalance() async {
    final directory = await getApplicationDocumentsDirectory();
    File file;
    DateTime _now = DateTime.now();

    if (!File(directory.path + '/last_date.txt').existsSync()) {
      //om en fil med datum ej finns så genereras en med värdet 0 i
      file =
          await File(directory.path + '/last_date.txt').create(recursive: true);
      file.writeAsString('0');
    } else {
      file = File(directory.path + '/last_date.txt');
    }
    String lastDate = await file.readAsString();

    if (_now.day != int.parse(lastDate)) {
      //om datumet som är lagrat ej är samma som dagens datum så får användaren $200
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: 200,
                add: true);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    }
    file.writeAsString('${_now.day}'); //skriver dagens datum till filen
    try {
      //metoden som hämtar statistik
      await Provider.of<StatisticsHandler>(context, listen: false)
          .setUpStatistics(context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

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
          _userAndSettingsButtons()
        ],
      ),
    );
  }

  //widget för bakgrundsbilden
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

//widget för att fadea bilden
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
        widthFactor: 0.6,
        heightFactor: 0.1,
        child: ElevatedButton(
          child: const Text('PLAY NOW'),
          onPressed: () {
            try {
              //skapar användar statistik om det inte redan finns ett dokument kopplat till det användar-id:t
              Provider.of<FirestoreImplementation>(context, listen: false)
                  .createNewUsrStat(
                      context: context,
                      userId: Provider.of<FirebaseAuthImplementation>(context,
                              listen: false)
                          .getUserId()!);
            } on Exception catch (e) {
              ErrorHandling().errorHandling(e, context);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GamePage(),
              ),
            );
          },
        ),
      ),
    );
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
                builder: (context) => const HowToPlayPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  //Widget för statistik knapp
  Widget _statisticsButton() {
    return Align(
      alignment: const Alignment(0, 0.5),
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.1,
        child: ElevatedButton(
          child: const Text('STATISTICS'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatisticsPage(),
              ),
            );
          },
        ),
      ),
    );
  }

//Widget för UserIcon och Settingsicon
  Widget _userAndSettingsButtons() {
    return Align(
      alignment: const Alignment(1.95, 0.89),
      child: Row(
        children: [
          const SizedBox(
            width: 250,
            height: 1,
          ),
          IconButton(
            icon: const Icon(Icons.portrait_rounded),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileInformationPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 50,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
