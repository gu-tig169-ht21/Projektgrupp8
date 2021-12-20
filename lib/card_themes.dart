//ändra bilder på de klädda korten
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class StandardDeck {}

//klass för starwars kortleken
class StarWarsDeck {
  static PlayingCardViewStyle get starWarsStyle {
    return PlayingCardViewStyle(
      suitStyles: {
        //tema för spader
        Suit.spades: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset(''),
            CardValue.queen: (context) => Image.asset(''),
            CardValue.king: (context) => Image.asset(''),
            CardValue.ace: (context) => Image.asset('')
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
            CardValue.jack: (context) => Image.asset(''),
            CardValue.queen: (context) => Image.asset(''),
            CardValue.king: (context) => Image.asset(''),
            CardValue.ace: (context) => Image.asset('')
          },
        ),

        //tema för ruter
        Suit.diamonds: SuitStyle(
          builder: (context) => const FittedBox(
            fit: BoxFit.fitHeight,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) => Image.asset(''),
            CardValue.queen: (context) => Image.asset(''),
            CardValue.king: (context) => Image.asset(''),
            CardValue.ace: (context) => Image.asset('')
          },
        ),
        //tema för klöver
        Suit.clubs: SuitStyle(
            builder: (context) => const FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
            style: const TextStyle(color: Colors.brown),
            cardContentBuilders: {
              CardValue.jack: (context) => Image.asset(''),
              CardValue.queen: (context) => Image.asset(''),
              CardValue.king: (context) => Image.asset(''),
              CardValue.ace: (context) => Image.asset('')
            })
      },
    );
  }
}

//klass för goldendeck kortleken
class GoldenDeck {
  static PlayingCardViewStyle get goldenStyle {
    return PlayingCardViewStyle(
      suitStyles: {
        //tema för spader
        Suit.spades: SuitStyle(
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
            CardValue.queen: (context) => Image.asset('assets/Gold2.jpg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('')
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
            CardValue.queen: (context) => Image.asset('assets/Gold2.jpg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('')
          },
        ),

        //tema för ruter
        Suit.diamonds: SuitStyle(
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
            CardValue.queen: (context) => Image.asset('assets/Gold2.jpg'),
            CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
            CardValue.ace: (context) => Image.asset('')
          },
        ),
        //tema för klöver
        Suit.clubs: SuitStyle(
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
              CardValue.queen: (context) => Image.asset('assets/Gold2.jpg'),
              CardValue.king: (context) => Image.asset('assets/Gold3.jpg'),
              CardValue.ace: (context) => Image.asset('')
            })
      },
    );
  }
}
