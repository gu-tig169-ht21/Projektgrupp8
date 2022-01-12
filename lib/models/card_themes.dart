import 'package:flutter/material.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import '../game_engine/error_handling.dart';

class CardThemeHandler extends ChangeNotifier {
  var _playingCardThemeMode = PlayingCardsThemes.standardStyle;
  String _cardStyleString = 'Standard';
  int _chosenPageViewCard = 0;
  final int _starWarsDeckPrice = 100;
  final int _goldenDeckPrice = 1000;
  bool _starWarsDeckUnlocked = false;
  bool _goldenDeckUnlocked = false;
  int _balance = 0;

  get getStarWarsDeckUnlocked {
    return _starWarsDeckUnlocked;
  }

  get getGoldenDeckUnlocked {
    return _goldenDeckUnlocked;
  }

  get getStarWarsDeckPrice {
    return _starWarsDeckPrice;
  }

  get getGoldenDeckPrice {
    return _goldenDeckPrice;
  }

  get getChosenPageViewCard {
    return _chosenPageViewCard;
  }

  set setChosenPageViewCard(int i) {
    _chosenPageViewCard = i;
    notifyListeners();
  }

  get getCardStyleString {
    return _cardStyleString;
  }

  get getPlayingCardThemeMode {
    return _playingCardThemeMode;
  }

  void fetchBalance({required BuildContext context}) async {
    try {
      _balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
      notifyListeners();
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

  int getBalance({required BuildContext context}) {
    fetchBalance(context: context);
    return _balance;
  }

  Future<void> setUpCardThemes({required BuildContext context}) async {
    try {
      changePlayingCardsThemes(
          style:
              await Provider.of<FirestoreImplementation>(context, listen: false)
                  .getChosenDeckTheme(
                      context: context,
                      userId: Provider.of<FirebaseAuthImplementation>(context,
                              listen: false)
                          .getUserId()!),
          context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    try {
      _starWarsDeckUnlocked =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getUnlockedDeck(
                  context: context,
                  deck: 'StarWars',
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    try {
      _goldenDeckUnlocked =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getUnlockedDeck(
                  context: context,
                  deck: 'Golden',
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

  void setDeckUnlocked(
      {required String starWarsOrGolden, required BuildContext context}) {
    if (starWarsOrGolden == 'StarWars') {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false).unlockDeck(
            context: context,
            deck: starWarsOrGolden,
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);
        _starWarsDeckUnlocked = true;
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    } else if (starWarsOrGolden == 'Golden') {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false).unlockDeck(
            context: context,
            deck: starWarsOrGolden,
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);
        _goldenDeckUnlocked = true;
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    }
  }

  bool getDeckUnlocked(
      {required String starWarsOrGolden, required BuildContext context}) {
    if (starWarsOrGolden == 'StarWars') {
      return _starWarsDeckUnlocked;
    } else if (starWarsOrGolden == 'Golden') {
      return _goldenDeckUnlocked;
    } else {
      return true;
    }
  }

  //if-sats som bestämmer kort-temat utifrån scrollvyn
  void changePlayingCardsThemes(
      {required String style, required BuildContext context}) {
    if (style == 'Standard') {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false)
            .changeDeckTheme(
                context: context,
                deck: style,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!);
        _playingCardThemeMode = PlayingCardsThemes.standardStyle;
        _cardStyleString = style;
        notifyListeners();
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    } else if (style == 'StarWars') {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false)
            .changeDeckTheme(
                context: context,
                deck: style,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!);
        _playingCardThemeMode = PlayingCardsThemes.starWarsStyle;
        _cardStyleString = style;
        notifyListeners();
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    } else if (style == 'Golden') {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false)
            .changeDeckTheme(
                context: context,
                deck: style,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!);
        _playingCardThemeMode = PlayingCardsThemes.goldenStyle;
        _cardStyleString = style;
        notifyListeners();
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    }
  }

  //funktion som testar om man kan köpa kortlekarna
  bool affordDeck(String style, BuildContext context) {
    fetchBalance(context: context);
    int value = 0;

    if (style == 'StarWars') {
      value = _starWarsDeckPrice;
    } else {
      value = _goldenDeckPrice;
    }

    if (_balance >= value) {
      return true;
    } else {
      return false;
    }
  }
}

//funktion för starwars kortleken
class PlayingCardsThemes {
  static PlayingCardViewStyle get standardStyle {
    return const PlayingCardViewStyle();
  }

  static PlayingCardViewStyle get starWarsStyle {
    return PlayingCardViewStyle(
      suitStyles: {
        //tema för spader
        Suit.spades: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Text('♠'),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/grevious.jpg'),
            CardValue.queen: (context) => Image.asset('assets/boKatan.jpg'),
            CardValue.king: (context) => Image.asset('assets/darthMaul.jpg'),
            CardValue.ace: (context) => Image.asset('assets/Palpatine.png')
          },
        ),
        //tema för hjärter
        Suit.hearts: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/hanSolo.jpg'),
            CardValue.queen: (context) => Image.asset('assets/leia.jpg'),
            CardValue.king: (context) => Image.asset('assets/kenobi.jpg'),
            CardValue.ace: (context) => Image.asset('assets/yoda.jpg')
          },
        ),

        //tema för ruter
        Suit.diamonds: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Text('♦'),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/chewbacca.jpg'),
            CardValue.queen: (context) =>
                Image.asset('assets/QueenAmidala1.jpg'),
            CardValue.king: (context) => Image.asset('assets/quiGonJinn.jpg'),
            CardValue.ace: (context) => Image.asset('assets/luke.jpg')
          },
        ),
        //tema för klöver
        Suit.clubs: SuitStyle(
            builder: (context) => const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text('♣️'),
                ),
            style: const TextStyle(color: Colors.brown),
            cardContentBuilders: {
              CardValue.jack: (context) => Image.asset('assets/dinDjarin.jpg'),
              CardValue.queen: (context) => Image.asset('assets/ahsoka.jpg'),
              CardValue.king: (context) =>
                  Image.asset('assets/countDooku2.jpg'),
              CardValue.ace: (context) => Image.asset('assets/darthVader.jpg')
            })
      },
    );
  }

//funktion för GoldenDeck
  static PlayingCardViewStyle get goldenStyle {
    return PlayingCardViewStyle(
      suitStyles: {
        //tema för spader
        Suit.spades: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Text('♠'),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/Gold1.jpg'),
            CardValue.queen: (context) => Image.asset('assets/Gold4.jpeg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('assets/Gold2.png')
          },
        ),
        //tema för hjärter
        Suit.hearts: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/Gold1.jpg'),
            CardValue.queen: (context) => Image.asset('assets/Gold4.jpeg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('assets/Gold2.png')
          },
        ),

        //tema för ruter
        Suit.diamonds: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Text('♦'),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset('assets/Gold1.jpg'),
            CardValue.queen: (context) => Image.asset('assets/Gold4.jpeg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('assets/Gold2.png')
          },
        ),
        //tema för klöver
        Suit.clubs: SuitStyle(
            builder: (context) => const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text('♣️'),
                ),
            style: const TextStyle(color: Colors.brown),
            cardContentBuilders: {
              CardValue.jack: (context) => Image.asset('assets/Gold1.jpg'),
              CardValue.queen: (context) => Image.asset('assets/Gold4.jpeg'),
              CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
              CardValue.ace: (context) => Image.asset('assets/Gold2.png')
            })
      },
    );
  }
}
