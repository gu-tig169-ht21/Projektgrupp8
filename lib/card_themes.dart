//ändra bilder på de klädda korten

import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class standardDeck {}

class starWarsDeck {
  // static PlayingCardViewStyle get starWarsStyle {
  //   return PlayingCardViewStyle(
  static PlayingCardViewStyle starWarsStyle = PlayingCardViewStyle(
    suitStyles: {
      Suit.spades: SuitStyle(
          builder: (context) => const FittedBox(
                fit: BoxFit.fitHeight,
              ),
          style: const TextStyle(color: Colors.brown),
          cardContentBuilders: {
            CardValue.jack: (context) =>
                Image.asset('assets/bakgrundBlackjack.jpg'),
            CardValue.queen: (context) =>
                Image.asset('assets/bakgrundBlackjack.jpg'),
            CardValue.king: (context) =>
                Image.asset('assets/bakgrundBlackjack.jpg'),
          })
    },
  );
}

class goldenDeck {}
