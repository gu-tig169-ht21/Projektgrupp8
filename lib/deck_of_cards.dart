import 'package:playing_cards/playing_cards.dart';
import 'dart:math';

class DeckOfCards {
  List<PlayingCard> deck = standardFiftyTwoCardDeck(); //ska den ligga här?
  var random = Random();

  PlayingCard pickACard() {
    //returnerar ett kort och tar bort det ur leken
    int i = random.nextInt(deck.length + 1);
    PlayingCard card = deck[i];
    deck.removeAt(i);
    return card;
  }

  void resetDeck() {
    //resettar kortleken
    deck = standardFiftyTwoCardDeck();
  }
}
