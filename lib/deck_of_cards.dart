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
          return 1;
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
    for (PlayingCard card in hand) {
      value += valueOfCard(card);
    }
    return value;
  }
}
