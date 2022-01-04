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
  bool splitStop = false;
  int balance = 200;
  int playerBet = 0;
  int splitBet = 0;
  bool doubled = false;
  bool split = false;
  String winCondition = 'NoWinnerYet';
  String splitWinCondition = 'NoWinnerYet';
  bool dealerCardShown = false;
  bool canBet = true;
  bool canSplit = true;
  bool canDouble = true;
  int rounds = 1;

  BlackJack() {
    //funktioner som görs vid första instansiering
    resetDeck();
    //hämta saldo från server här
    clearHands();

    startingHands();
  }
  int get getRounds {
    return rounds;
  }

  bool get getCanDouble {
    return canDouble;
  }

  bool get getCanSplit {
    return canSplit;
  }

  String get getSplitWinCondition {
    return splitWinCondition;
  }

  bool get getSplit {
    return split;
  }

  int get getSplitBet {
    return splitBet;
  }

  bool get getCanBet {
    return canBet;
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

  int get getBalance {
    return balance;
  }

  set setCanBet(bool value) {
    canBet = value;
    notifyListeners();
  }

  set setCanSplit(bool value) {
    canSplit = value;
    notifyListeners();
  }

  set setCanDouble(bool value) {
    canDouble = value;
    notifyListeners();
  }

  void subtractFromBalance(int i) {
    balance -= i;
    notifyListeners();
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
    splitWinCondition = 'NoWinnerYet';
    dealerCardShown = false;
    canDouble = true;
    canSplit = true;
    setCanBet = true;
    rounds = 1;
    startingHands();
    notifyListeners();
  }

  bool checkRound() {
    if (rounds == 1) {
      return true;
    } else {
      return false;
    }
  }

  void incrementRounds() {
    rounds++;
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

    blackJackOrBustCheck(playerOrSplit: 'Player');

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
    stop(
        playerOrDealerOrSplit:
            'Dealer'); //när dealern inte får göra mera stannar den
  }

  void stop({required String playerOrDealerOrSplit}) {
    //sätter stanna variablerna till true
    switch (playerOrDealerOrSplit) {
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
      case 'Split':
        {
          splitStop = true;
          notifyListeners();
          break;
        }
      default:
        {
          break;
        }
    }
  }

  void winnings({required String playerOrSplit}) {
    //delar upp vinsten, beroende på angivet argument för player eller split bet
    //hanterar dina vunna riksdaler
    if (playerOrSplit == 'Player') {
      balance = balance + playerBet * 2;
      notifyListeners();
    } else if (playerOrSplit == 'Split') {
      balance = balance + splitBet * 2;
      notifyListeners();
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void drawBet({required String playerOrSplit}) {
    //ger tillbaka dina pengar om du får en draw med dealern
    if (playerOrSplit == 'Player') {
      balance += playerBet;
    } else if (playerOrSplit == 'Split') {
      balance += splitBet;
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void increaseBet(int bet) {
    //returna det nya bettet istället
    //ökar spelarens insats
    if (bet <= balance) {
      playerBet += bet;
      balance -= bet;
      notifyListeners();
    } else if (bet > balance) {
      throw Exception('Not enough money');
    } else {
      throw Exception('Something went wrong setting bet');
    }
  }

  void getNewCard({required String playerOrSplit}) {
    incrementRounds();
    //drar ett nytt kort för spelaren
    switch (playerOrSplit) {
      case 'Player':
        {
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
          break;
        }
      case 'Split':
        {
          PlayingCard card = DeckOfCards().pickACard(deck);
          splitHand.add(card);
          deck.removeWhere((element) => element == card);
          notifyListeners();
          break;
        }
      default:
        {
          break;
        }
    }
  }

  void testingDouble() {
    if (balance >= playerBet) {
      canDouble = true;

      notifyListeners();
    } else {
      canDouble = false;
      notifyListeners();
    }
  }

  void doDouble() {
    incrementRounds();
    //en dubblering av insatsen

    if (balance >= playerBet) {
      balance -= playerBet;
      playerBet = playerBet * 2;
      doubled = true;

      notifyListeners();
    } else {
      canDouble = false;
      notifyListeners();
    }
  }

  void testingSplit() {
    if (playerHand[0].value == playerHand[1].value && balance >= playerBet) {
      canSplit = true;
      notifyListeners();
    } else {
      canSplit = false;
      notifyListeners();
    }
  }

  void doSplit() {
    incrementRounds();
    //gör en split om det väljs och kraven uppfylls
    PlayingCard card = DeckOfCards().pickACard(deck);
    if (playerHand[0].value == playerHand[1].value && balance >= playerBet) {
      splitHand.add(playerHand[1]);
      playerHand.removeAt(1);

      splitBet = playerBet;
      balance -= splitBet;
      playerHand.add(card);
      deck.removeWhere((element) => element == card);
      card = DeckOfCards().pickACard(deck);
      splitHand.add(card);
      deck.removeWhere((element) => element == card);
      split = true;
      notifyListeners();
    } else {
      canSplit = false;
      notifyListeners();
    }
  }

  void winOrLose({required String playerOrSplit}) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
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
      } else if (playerScore > 21) {
        showDealercard();
        //spelaren blev tjock
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealercard();
        //dealern blev tjock
        winCondition = 'Win';
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
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealercard();
        //båda har blackjack
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        showDealercard();
        //dealern har blackjack
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealercard();
        //spelaren har blackjack
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealercard();
        //spelaren blev tjock
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealercard();
        //dealern blev tjock
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (dealerScore == playerScore) {
        showDealercard();
        //båda fick samma poäng
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (playerScore > dealerScore) {
        showDealercard();
        //spelaren fick mer poäng
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore < dealerScore) {
        showDealercard();
        //dealern fick mer poäng
        splitWinCondition = 'Lose';
        notifyListeners();
      } else {
        splitWinCondition = 'NoWinnerYet';
      }
    } else {
      throw Exception('Didnt choose hand');
    }
  }

  void blackJackOrBustCheck({required String playerOrSplit}) {
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player' && split) {
      playerScore = DeckOfCards().handValue(playerHand);
      if (dealerScore == 21 && playerScore == 21) {
        //båda har blackjack
        winCondition = 'Draw';
        stop(playerOrDealerOrSplit: 'Player');
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        stop(playerOrDealerOrSplit: 'Player');
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        //spelaren har blackjack
        stop(playerOrDealerOrSplit: 'Player');
        winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        //spelaren blev tjock
        stop(playerOrDealerOrSplit: 'Player');
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        //dealern blev tjock
        stop(playerOrDealerOrSplit: 'Player');
        winCondition = 'Win';
        notifyListeners();
      } else {
        winCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
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
      } else if (playerScore > 21) {
        showDealercard();
        //spelaren blev tjock
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealercard();
        //dealern blev tjock
        winCondition = 'Win';
        notifyListeners();
      } else {
        winCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealercard();
        //båda har blackjack
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        showDealercard();
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealercard();
        //spelaren har blackjack
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealercard();
        //spelaren blev tjock
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealercard();
        //dealern blev tjock
        splitWinCondition = 'Win';
        notifyListeners();
      } else {
        splitWinCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else {
      throw Exception('Didnt choose hand');
    }
  }
}
