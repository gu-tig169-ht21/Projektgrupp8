import 'package:my_first_app/game_page.dart';
import 'package:playing_cards/playing_cards.dart';

import 'deck_of_cards.dart';

class BlackJack {
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> splitHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];
  int playerBet = 0;
  int splitBet = 0;
  bool doubled = false;
  bool split = false;

  void startNewGame() {
    //här skapas ett nytt spel och startkort delas ut, ska kanske ha något med bet att göra
    playerHand.clear();
    dealerHand.clear();

    playerHand.add(DeckOfCards().pickACard());
    dealerHand.add(DeckOfCards().pickACard());
    playerHand.add(DeckOfCards().pickACard());
    dealerHand.add(DeckOfCards().pickACard());
  }

  void dealersTurn() {
    if (DeckOfCards().handValue(dealerHand) < 17) {
      dealerHand.add(DeckOfCards().pickACard());
      //lägg till funktion för vinst och förlust attribut
    } else {
      //lägg till funktion för at stanna
    }
  }

  bool increaseBet(int bet) {
    //ökar spelarens insats
    if (bet <= saldo) {
      playerBet = bet;
      saldo -= bet;
      return true;
    } else if (bet > saldo) {
      return false;
    } else {
      return false;
    }
  }

  bool getNewCard() {
    //drar ett nytt kort för spelaren
    if (!doubled) {
      playerHand.add(DeckOfCards().pickACard());
      return true;
    } else if (doubled && playerHand.length < 3) {
      playerHand.add(DeckOfCards().pickACard());
      return true;
    } else {
      return false;
    }
  }

  bool doDouble() {
    //en dubblering av insatsen
    if (saldo >= playerBet) {
      saldo -= playerBet;
      playerBet = playerBet * 2;
      doubled = true;
      return true;
    } else {
      return false;
    }
  }

  bool doSplit() {
    //gör en split om det väljs och kraven uppfylls
    if (DeckOfCards().valueOfCard(playerHand[0]) ==
            DeckOfCards().valueOfCard(playerHand[1]) &&
        saldo >= playerBet) {
      splitHand.add(playerHand[1]);
      playerHand.removeAt(1);

      splitBet = playerBet;
      saldo -= splitBet;
      playerHand.add(DeckOfCards().pickACard());
      splitHand.add(DeckOfCards().pickACard());

      split = true;
      return true;
    } else {
      split = false;
      return false;
    }
  }
}
