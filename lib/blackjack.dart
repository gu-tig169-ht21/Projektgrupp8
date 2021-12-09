import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/game_page.dart';
import 'package:playing_cards/playing_cards.dart';

import 'deck_of_cards.dart';

class BlackJack extends ChangeNotifier {
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> splitHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];
  bool dealerStop = false;
  bool playerStop = false;
  int playerBet = 0;
  int splitBet = 0;
  bool doubled = false;
  bool split = false;
  String winCondition = '';

  void clearHands() {
    playerHand.clear();
    dealerHand.clear();
    splitHand.clear();
    notifyListeners();
  }

  void startingHands() {
    PlayingCard card = DeckOfCards().pickACard(deck);
    playerHand.add(card);
    deck.removeWhere((element) => element == card);
    card = DeckOfCards().pickACard(deck);
    dealerHand.add(card);
    deck.removeWhere((element) => element == card);
    card = DeckOfCards().pickACard(deck);
    playerHand.add(card);
    deck.removeWhere((element) => element == card);
    card = DeckOfCards().pickACard(deck);
    dealerHand.add(card);
    deck.removeWhere((element) => element == card);
    notifyListeners();
  }

  void resetDeck() {
    deck = standardFiftyTwoCardDeck();
    notifyListeners();
  }

  void dealersTurn() {
    PlayingCard card = DeckOfCards().pickACard(deck);

    if (DeckOfCards().handValue(dealerHand) < 17) {
      dealerHand.add(card);
      deck.removeWhere((element) => element == card);
      notifyListeners();
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
          notifyListeners();
          break;
        }
      case 'Dealer':
        {
          dealerStop = true;
          notifyListeners();
          break;
        }
      default:
        {
          break;
        }
    }
  }

  void increaseBet(int bet) {
    //returna det nya bettet istället
    //ökar spelarens insats
    if (bet <= saldo) {
      playerBet += bet;
      saldo -= bet;
      notifyListeners();
    } else if (bet > saldo) {
      throw Exception('Not enough money');
    } else {
      throw Exception('Something went wrong setting bet');
    }
  }

  void getNewCard() {
    //drar ett nytt kort för spelaren
    PlayingCard card = DeckOfCards().pickACard(deck);
    if (!doubled) {
      playerHand.add(card);
      deck.removeWhere((element) => element == card);
      notifyListeners();
    } else if (doubled && playerHand.length < 3) {
      playerHand.add(card);
      deck.removeWhere((element) => element == card);
      notifyListeners();
    } else {
      throw Exception('Cant pick new card');
    }
  }

  void doDouble() {
    //en dubblering av insatsen
    if (saldo >= playerBet) {
      saldo -= playerBet;
      playerBet = playerBet * 2;
      doubled = true;
      notifyListeners();
    } else {
      throw Exception('Not enough money');
    }
  }

  void doSplit() {
    //gör en split om det väljs och kraven uppfylls
    PlayingCard card = DeckOfCards().pickACard(deck);
    if (DeckOfCards().valueOfCard(playerHand[0]) ==
            DeckOfCards().valueOfCard(playerHand[1]) &&
        saldo >= playerBet) {
      splitHand.add(playerHand[1]);
      playerHand.removeAt(1);

      splitBet = playerBet;
      saldo -= splitBet;
      playerHand.add(card);
      deck.removeWhere((element) => element == card);
      card = DeckOfCards().pickACard(deck);
      splitHand.add(card);
      deck.removeWhere((element) => element == card);
      split = true;
      notifyListeners();
    } else {
      throw Exception('Cant do split');
    }
  }

  void winOrLose(List<PlayingCard> hand) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore = DeckOfCards().handValue(hand);

    if (dealerScore == 21 && playerScore == 21) {
      //båda har blackjack
      winCondition = 'Draw';
      notifyListeners();
    } else if (dealerScore == 21 && playerScore != 21) {
      //dealern har blackjack
      winCondition = 'Lose';
      notifyListeners();
    } else if (dealerScore != 21 && playerScore == 21) {
      //spelaren har blackjack
      winCondition = 'Win';
      notifyListeners();
    } else if (dealerScore > 21) {
      //dealern blev tjock
      winCondition = 'Win';
      notifyListeners();
    } else if (playerScore > 21) {
      //spelaren blev tjock
      winCondition = 'Lose';
      notifyListeners();
    } else if (dealerScore == playerScore) {
      //båda fick samma poäng
      winCondition = 'Draw';
      notifyListeners();
    } else if (playerScore > dealerScore) {
      //spelaren fick mer poäng
      winCondition = 'Win';
      notifyListeners();
    } else if (playerScore < dealerScore) {
      //dealern fick mer poäng
      winCondition = 'Lose';
      notifyListeners();
    } else {
      throw Exception('Något gick fel vid poängräkningen');
    }
  }
}
