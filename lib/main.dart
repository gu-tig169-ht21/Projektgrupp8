import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:my_first_app/card_themes.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:my_first_app/firebase_options.dart';
import 'package:my_first_app/how_to_play.dart';
import 'package:my_first_app/settings_page.dart';
import 'package:my_first_app/start_page.dart';
import 'package:my_first_app/theme.dart';
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
      ChangeNotifierProvider(create: (context) => ChangeTheme()),
      ChangeNotifierProvider(create: (context) => HowToPlay()),
      ChangeNotifierProvider(
        create: (context) => BlackJack(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlayingCardsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FirebaseAuthImplementation(),
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
      home: startUp(context),
      theme: ThemeCustom.StandardTheme,
      darkTheme: ThemeCustom.DarkTheme,
      themeMode: Provider.of<ChangeTheme>(context, listen: true).getThemeMode,
    );
  }

  Widget startUp(BuildContext context) {
    if (Provider.of<FirebaseAuthImplementation>(context, listen: true)
        .isUserLoggedIn()) {
      return const StartPage();
    } else {
      return const LoginPage();
    }
  }
}

//TODO: sätt alla providervariabler till private!!!
