import 'package:playing_cards/playing_cards.dart';

import 'deck_of_cards.dart';

class BlackJack {
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];

  void startNewGame() {
    playerHand.clear();
    dealerHand.clear();

    playerHand.add(DeckOfCards().pickACard());
    dealerHand.add(DeckOfCards().pickACard());
    playerHand.add(DeckOfCards().pickACard());
    dealerHand.add(DeckOfCards().pickACard());
  }
}
