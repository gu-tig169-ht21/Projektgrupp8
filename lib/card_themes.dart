import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';

class PlayingCardsProvider extends ChangeNotifier {
  var playingcardThemeMode = PlayingCardsThemes.standardStyle;
  String cardStyleString = 'Standard';

  get getCardStyleString {
    return cardStyleString;
  }

  get getPlayingcardThemeMode {
    return playingcardThemeMode;
  }

  //if-sats som bestämmer kort-temat utifrån scrollvyn
  void changePlayingCardsThemes(String style) {
    if (style == 'Standard') {
      playingcardThemeMode = PlayingCardsThemes.standardStyle;
      cardStyleString = style;
      notifyListeners();
    } else if (style == 'StarWars') {
      playingcardThemeMode = PlayingCardsThemes.starWarsStyle;
      cardStyleString = style;
      notifyListeners();
    } else if (style == 'Golden') {
      playingcardThemeMode = PlayingCardsThemes.goldenStyle;
      cardStyleString = style;
      notifyListeners();
    }
  }

  //funktion som testar om man kan köpa kortlekarna
  bool affordDeck(String style, BuildContext context) {
    int money = Provider.of<BlackJack>(context, listen: false).getBalance;
    int value = 0;

    if (style == 'StarWars') {
      value = 5;
    } else {
      value = 10000;
    }

    if (money >= value) {
      return true;
    } else {
      return false;
    }
  }
}

//TODO:
//-En if sats som kollar om man har köpt den eller inte innan
//lyssna på deras balance-variabel
//skapa 2 vaiablar för kortens kostnad
// jämföra dessa i en if sats

//Funktion som gör att man kan köpa och att den sedan står som upplåst

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
