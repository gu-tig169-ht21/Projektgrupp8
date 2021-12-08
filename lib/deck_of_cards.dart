import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'dart:math';

class DeckOfCards {
  List<PlayingCard> deck = standardFiftyTwoCardDeck(); //ska den ligga här?
  final _random = Random();

  PlayingCard pickACard() {
    //returnerar ett kort och tar bort det ur leken
    int i = _random.nextInt(deck.length + 1);
    PlayingCard card = deck[i];
    deck.removeAt(i);
    return card;
  }

  void resetDeck() {
    //resettar kortleken
    deck = standardFiftyTwoCardDeck();
  }

  int valueOfCard(PlayingCard card) {
    //returnerar värdet av ett specifikt kort
    switch (card.value) {
      case CardValue.ace:
        {
          return 11;
        }
      case CardValue.two:
        {
          return 2;
        }
      case CardValue.three:
        {
          return 3;
        }
      case CardValue.four:
        {
          return 4;
        }
      case CardValue.five:
        {
          return 5;
        }
      case CardValue.six:
        {
          return 6;
        }
      case CardValue.seven:
        {
          return 7;
        }
      case CardValue.eight:
        {
          return 8;
        }
      case CardValue.nine:
        {
          return 9;
        }
      case CardValue.ten:
        {
          return 10;
        }
      case CardValue.jack:
        {
          return 10;
        }
      case CardValue.queen:
        {
          return 10;
        }
      case CardValue.king:
        {
          return 10;
        }
    }
  }

  int handValue(List<PlayingCard> hand) {
    //returnerar värdet av en "hand" (lista av kort)
    int value = 0;
    var test = hand.where((element) => element.value == CardValue.ace);

    for (PlayingCard card in hand) {
      value += valueOfCard(card);
    }
    if (value > 21 && test.isNotEmpty && test.length == 1) {
      value -= 10;
    } else if (value > 21 && test.isNotEmpty && test.length == 2) {
      if (value - 10 <= 21) {
        value -= 10;
      } else {
        value -= 20;
      }
    } else if (value > 21 && test.isNotEmpty && test.length == 3) {
      if (value - 10 <= 21) {
        value -= 10;
      } else if (value - 20 <= 21) {
        value -= 20;
      } else {
        value -= 30;
      }
    } else if (value > 21 && test.isNotEmpty && test.length == 4) {
      if (value - 10 <= 21) {
        value -= 10;
      } else if (value - 20 <= 21) {
        value -= 20;
      } else if (value - 30 <= 21) {
        value -= 30;
      } else {
        value -= 40;
      }
    }

    return value;
  }
}
