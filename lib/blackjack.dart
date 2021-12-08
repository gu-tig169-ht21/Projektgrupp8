import 'package:my_first_app/game_page.dart';
import 'package:playing_cards/playing_cards.dart';

import 'deck_of_cards.dart';

class BlackJack {
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> splitHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];
  bool dealerStop = false;
  bool playerStop = false;
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
      //Kör vinstfunktion när dealern blir tjock eller får blackjack
    } else {
      stop('Dealer');
    }
  }

  void stop(String playerOrDealer) {
    switch (playerOrDealer) {
      case 'Player':
        {
          playerStop = true;
          break;
        }
      case 'Dealer':
        {
          dealerStop = true;
          break;
        }
      default:
        {
          break;
        }
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

  String winOrLose(List<PlayingCard> hand) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore = DeckOfCards().handValue(hand);
    if (dealerScore == 21 && playerScore == 21) {
      //båda har blackjack
      return 'Draw';
    } else if (dealerScore == 21 && playerScore != 21) {
      //dealern har blackjack
      return 'Lose';
    } else if (dealerScore != 21 && playerScore == 21) {
      //spelaren har blackjack
      return 'Win';
    } else if (dealerScore > 21) {
      //dealern blev tjock
      return 'Win';
    } else if (playerScore > 21) {
      //spelaren blev tjock
      return 'Lose';
    } else if (dealerScore == playerScore) {
      //båda fick samma poäng
      return 'Draw';
    } else if (playerScore > dealerScore) {
      //spelaren fick mer poäng
      return 'Win';
    } else if (playerScore < dealerScore) {
      //dealern fick mer poäng
      return 'Lose';
    } else {
      throw Exception('Något gick fel vid poängräkningen');
    }
  }
}
