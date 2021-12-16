import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

import 'deck_of_cards.dart';

//om du gör en split så kör du i turordning, först agerar du färdigt med första handen sedan med nästa
//då behöver bara knapparna påverka olika varibaler beroende på om du agerar för splithanden eller bethanden

class BlackJack extends ChangeNotifier {
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> splitHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];
  bool dealerStop = false;
  bool playerStop = false;
  int saldo = 200;
  int playerBet = 0;
  int splitBet = 0;
  bool doubled = false;
  bool split = false;
  String winCondition = 'NoWinnerYet';
  bool dealerCardShown = false;

  BlackJack() {
    //funktioner som görs vid första instansiering
    resetDeck();
    //hämta saldo från server här
    clearHands();

    startingHands();
  }

  String get getWinCondition {
    return winCondition;
  }

  List<PlayingCard> get getPlayerHand {
    return playerHand;
  }

  List<PlayingCard> get getSplitHand {
    return splitHand;
  }

  List<PlayingCard> get getDealerHand {
    return dealerHand;
  }

  bool get getDealerCardShown {
    return dealerCardShown;
  }

  int get getPlayerBet {
    return playerBet;
  }

  void setUpNewGame() {
    //resettar alla variabler till defaultvärdet och drar nya kort
    resetDeck();
    clearHands();
    playerBet = 0;
    splitBet = 0;
    dealerStop = false;
    playerStop = false;
    doubled = false;
    split = false;
    winCondition = 'NoWinnerYet';
    dealerCardShown = false;

    startingHands();
    notifyListeners();
  }

  void showDealercard() {
    //ändrar dealerCardsShown till true
    dealerCardShown = true;
    notifyListeners();
  }

  void clearHands() {
    //tar bort kort från spelarnas händer
    playerHand.clear();
    dealerHand.clear();
    splitHand.clear();
    notifyListeners();
  }

  void startingHands() {
    //drar de första korten för dealrn och spelaren
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

    blackJackOrBustCheck('Player');

    notifyListeners();
  }

  void resetDeck() {
    //resettar kortleken
    deck = standardFiftyTwoCardDeck();
    notifyListeners();
  }

  void dealersTurn() {
    //funktionen för dealerns tur
    PlayingCard card;
    showDealercard();
    while (DeckOfCards().handValue(dealerHand) < 17) {
      //dealern drar kort till summan är över 17
      card = DeckOfCards().pickACard(deck);
      dealerHand.add(card);
      deck.removeWhere((element) => element == card);
      notifyListeners();
    }
    stop('Dealer'); //när dealern inte får göra mera stannar den
  }

  void stop(String playerOrDealer) {
    //sätter stanna variablerna till true
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

  void winnings(String playerOrSplit) {
    //delar upp vinsten, beroende på angivet argument för player eller split bet
    //hanterar dina vunna riksdaler
    if (playerOrSplit == 'Player') {
      saldo = saldo + playerBet * 2;
      notifyListeners();
    } else if (playerOrSplit == 'Split') {
      saldo = saldo + splitBet * 2;
      notifyListeners();
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void drawBet(String playerOrSplit) {
    //ger tillbaka dina pengar om du får en draw med dealern
    if (playerOrSplit == 'Player') {
      saldo += playerBet;
    } else if (playerOrSplit == 'Split') {
      saldo += splitBet;
    } else {
      throw Exception('Player or split not assigned');
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

  void winOrLose(String playerOrSplit) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
    } else {
      throw Exception('Didnt choose hand');
    }

    if (dealerScore == 21 && playerScore == 21) {
      showDealercard();
      //båda har blackjack
      winCondition = 'Draw';
      notifyListeners();
    } else if (dealerScore == 21 && playerScore != 21) {
      showDealercard();
      //dealern har blackjack
      winCondition = 'Lose';
      notifyListeners();
    } else if (dealerScore != 21 && playerScore == 21) {
      showDealercard();
      //spelaren har blackjack
      winCondition = 'Win';
      notifyListeners();
    } else if (dealerScore > 21) {
      showDealercard();
      //dealern blev tjock
      winCondition = 'Win';
      notifyListeners();
    } else if (playerScore > 21) {
      showDealercard();
      //spelaren blev tjock
      winCondition = 'Lose';
      notifyListeners();
    } else if (dealerScore == playerScore) {
      showDealercard();
      //båda fick samma poäng
      winCondition = 'Draw';
      notifyListeners();
    } else if (playerScore > dealerScore) {
      showDealercard();
      //spelaren fick mer poäng
      winCondition = 'Win';
      notifyListeners();
    } else if (playerScore < dealerScore) {
      showDealercard();
      //dealern fick mer poäng
      winCondition = 'Lose';
      notifyListeners();
    } else {
      winCondition = 'NoWinnerYet';
    }
  }

  void blackJackOrBustCheck(String playerOrSplit) {
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
    } else {
      throw Exception('Didnt choose hand');
    }

    if (dealerScore == 21 && playerScore == 21) {
      showDealercard();
      //båda har blackjack
      winCondition = 'Draw';
      notifyListeners();
    } else if (dealerScore == 21 && playerScore != 21) {
      //dealern har blackjack
      showDealercard();
      winCondition = 'Lose';
      notifyListeners();
    } else if (dealerScore != 21 && playerScore == 21) {
      showDealercard();
      //spelaren har blackjack
      winCondition = 'Win';
      notifyListeners();
    } else if (dealerScore > 21) {
      showDealercard();
      //dealern blev tjock
      winCondition = 'Win';
      notifyListeners();
    } else if (playerScore > 21) {
      showDealercard();
      //spelaren blev tjock
      winCondition = 'Lose';
      notifyListeners();
    } else {
      winCondition = 'NoWinnerYet';
      notifyListeners();
    }
  }
}
