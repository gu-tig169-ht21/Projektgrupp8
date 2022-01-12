import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/game_engine/blackjack.dart';
import 'package:my_first_app/models/card_themes.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:my_first_app/models/firebase/firebase_options.dart';
import 'package:my_first_app/views/how_to_play_page.dart';
import 'package:my_first_app/views/settings_page.dart';
import 'package:my_first_app/views/start_page.dart';
import 'package:my_first_app/models/statistics_handler.dart';
import 'package:my_first_app/theme_data/theme.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChangeNumberOfDecks()),
      ChangeNotifierProvider(create: (context) => ChangeTheme()),
      ChangeNotifierProvider(create: (context) => HowToPlayPage()),
      ChangeNotifierProvider(
        create: (context) => BlackJackGameEngine(),
      ),
      ChangeNotifierProvider(
        create: (context) => CardThemeHandler(),
      ),
      ChangeNotifierProvider(
        create: (context) => FirebaseAuthImplementation(),
      ),
      ChangeNotifierProvider(
        create: (context) => FirestoreImplementation(),
      ),
      ChangeNotifierProvider(create: (context) => StatisticsHandler()),
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
      home: _startUp(context),
      theme: ThemeCustom.StandardTheme,
      darkTheme: ThemeCustom.DarkTheme,
      themeMode: Provider.of<ChangeTheme>(context, listen: true).getThemeMode,
    );
  }

  Widget _startUp(BuildContext context) {
    bool testLogin = false;
    try {
      testLogin = Provider.of<FirebaseAuthImplementation>(context, listen: true)
          .isUserLoggedIn();
    } on Exception catch (e) {
      BlackJackGameEngine.errorHandling(e, context);
    }
    if (testLogin) {
      return const StartPage();
    } else {
      return const LoginPage();
    }
  }
}

//TODO: sätt alla providervariabler till private!!!
