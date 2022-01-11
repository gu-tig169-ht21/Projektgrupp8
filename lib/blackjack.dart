import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/card_themes.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import 'deck_of_cards.dart';

//om du gör en split så kör du i turordning, först agerar du färdigt med första handen sedan med nästa
//då behöver bara knapparna påverka olika variabler beroende på om du agerar för splithanden eller bethanden

//TODO: lägg till så att man kan använda flera kortlekar(ändra i fabbes och mogges kod, lägg in i blackjack providern)
//TODO: skapa koppling till databas

class BlackJack extends ChangeNotifier {
  List<PlayingCard> deck = standardFiftyTwoCardDeck();
  List<PlayingCard> playerHand = <PlayingCard>[];
  List<PlayingCard> splitHand = <PlayingCard>[];
  List<PlayingCard> dealerHand = <PlayingCard>[];
  bool dealerStop = false;
  bool playerStop = false;
  bool splitStop = false;
  //int balance = 200;
  int playerBet = 0;
  int splitBet = 0;
  bool doubled = false;
  bool split = false;
  bool splitTurn = false;
  String winCondition = 'NoWinnerYet';
  String splitWinCondition = 'NoWinnerYet';
  bool dealerCardShown = false;
  bool canBet = true;
  bool canSplit = true;
  bool canDouble = true;
  int rounds = 1;
  int numberOfDecks = 1;

  BlackJack() {
    //funktioner som görs vid första instansiering
    resetDeck();
    //hämta saldo från server här
    clearHands();

    startingHands();
  }

  bool get getDoubled {
    return doubled;
  }

  bool get getPlayerStop {
    return playerStop;
  }

  bool get getSplitStop {
    return splitStop;
  }

  bool get getDealerStop {
    return dealerStop;
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

  bool get getSplitTurn {
    return splitTurn;
  }

  set setSplitTurn(bool value) {
    splitTurn = value;
    notifyListeners();
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

  void subtractFromBalance(
      {required int i, required BuildContext context}) async {
    await Provider.of<FirestoreImplementation>(context, listen: false)
        .changeBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!,
            change: i,
            add: false);
    notifyListeners();
  }

  void addDecks(String a) {
    int decks = int.parse(a);
    if (decks == 1) {
      deck.clear();
      deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 2) {
      deck.clear();
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 3) {
      deck.clear();
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 4) {
      deck.clear();
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 5) {
      deck.clear();
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
      deck.addAll(standardFiftyTwoCardDeck());
    } else {
      deck = standardFiftyTwoCardDeck();
    }
    numberOfDecks = decks;
  }

  void setUpNewGame() {
    //resettar alla variabler till defaultvärdet och drar nya kort
    addDecks('$numberOfDecks');
    clearHands();
    playerBet = 0;
    splitBet = 0;
    dealerStop = false;
    splitStop = false;
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

  void forfeit({required BuildContext context}) async {
    await Provider.of<FirestoreImplementation>(context, listen: false)
        .changeBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!,
            change: playerBet ~/ 2,
            add: true);
    setUpNewGame();
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

  void showDealerCard() {
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
    //drar de första korten för dealer och spelaren
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

    if (handCheck(playerOrSplit: 'Player')) {
      stop(playerOrDealerOrSplit: 'Player');
      dealersTurn();
      winOrLose(playerOrSplit: 'Player');
    }

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
    showDealerCard();
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

  void winnings(
      {required String playerOrSplit, required BuildContext context}) async {
    //delar upp vinsten, beroende på angivet argument för player eller split bet
    //hanterar dina vunna riksdaler
    if (playerOrSplit == 'Player') {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: playerBet * 2,
              add: true);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
    } else if (playerOrSplit == 'Split') {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: playerBet * 2,
              add: true);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void drawBet(
      {required String playerOrSplit, required BuildContext context}) async {
    //ger tillbaka dina pengar om du får en draw med dealern
    if (playerOrSplit == 'Player') {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: playerBet,
              add: true);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
    } else if (playerOrSplit == 'Split') {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: playerBet,
              add: true);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void increaseBet({required int bet, required BuildContext context}) async {
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);
    //returna det nya bettet istället
    //ökar spelarens insats
    if (bet <= balance) {
      playerBet += bet;
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: bet,
              add: false);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else if (bet > balance) {
      throw Exception('Not enough money');
    } else {
      throw Exception('Something went wrong setting bet');
    }
  }

  void allIn({required BuildContext context}) async {
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);

    if (balance > 0) {
      playerBet = balance;
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: balance,
              add: false);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else if (balance <= 0) {
      throw Exception('Not enough money to go all in');
    } else {
      throw Exception('Something went wrong going all in');
    }
  }

  void addCardsToDB({required BuildContext context}) {
    for (PlayingCard card in playerHand) {
      Provider.of<FirestoreImplementation>(context, listen: false)
          .incrementCardInDB(
              card: card,
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!);
    }
    if (split) {
      for (PlayingCard card in splitHand) {
        Provider.of<FirestoreImplementation>(context, listen: false)
            .incrementCardInDB(
                card: card,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!);
      }
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

  void testingDouble({required BuildContext context}) async {
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);

    if (balance >= playerBet) {
      canDouble = true;
      notifyListeners();
    } else {
      canDouble = false;
      notifyListeners();
    }
  }

  void doDouble({required BuildContext context}) async {
    incrementRounds();
    //en dubblering av insatsen
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);

    if (balance >= playerBet) {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: playerBet,
              add: false);
      playerBet = playerBet * 2;
      doubled = true;
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else {
      canDouble = false;
      notifyListeners();
    }
  }

  void testingSplit({required BuildContext context}) async {
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);

    if (playerHand[0].value == playerHand[1].value &&
        balance >= playerBet &&
        rounds == 1) {
      canSplit = true;
      notifyListeners();
    } else {
      canSplit = false;
      notifyListeners();
    }
  }

  void doSplit({required BuildContext context}) async {
    int balance = await Provider.of<FirestoreImplementation>(context,
            listen: false)
        .getBalance(
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!);
    //gör en split om det väljs och kraven uppfylls
    PlayingCard card = DeckOfCards().pickACard(deck);
    if (playerHand[0].value == playerHand[1].value &&
        balance >= playerBet &&
        rounds == 1) {
      splitHand.add(playerHand[1]);
      playerHand.removeAt(1);

      splitBet = playerBet;
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: splitBet,
              add: false);
      Provider.of<PlayingCardsProvider>(context, listen: false)
          .fetchBalance(context: context);
      playerHand.add(card);
      deck.removeWhere((element) => element == card);
      card = DeckOfCards().pickACard(deck);
      splitHand.add(card);
      deck.removeWhere((element) => element == card);
      split = true;

      if (handCheck(playerOrSplit: 'Player') &&
          handCheck(playerOrSplit: 'Split')) {
        stop(playerOrDealerOrSplit: 'Player');
        stop(playerOrDealerOrSplit: 'Split');
        dealersTurn();
        winOrLose(playerOrSplit: 'Player');
        winOrLose(playerOrSplit: 'Split');
      } else if (handCheck(playerOrSplit: 'Player')) {
        stop(playerOrDealerOrSplit: 'Player');
        winOrLose(playerOrSplit: 'Player');
        setSplitTurn = true;
      } else if (handCheck(playerOrSplit: 'Split')) {
        stop(playerOrDealerOrSplit: 'Split');
        winOrLose(playerOrSplit: 'Split');
      }

      notifyListeners();
    } else {
      canSplit = false;
      notifyListeners();
    }
    incrementRounds();
  }

  void winOrLose({required String playerOrSplit}) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
      if (dealerScore == 21 && playerScore == 21) {
        split ? null : showDealerCard();
        //båda har blackjack
        winCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        split ? null : showDealerCard();
        //dealern har blackjack
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        split ? null : showDealerCard();
        //spelaren har blackjack
        winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        split ? null : showDealerCard();
        //spelaren blev tjock
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        split ? null : showDealerCard();
        //dealern blev tjock
        winCondition = 'Win';
        notifyListeners();
      } else if (dealerScore == playerScore) {
        split ? null : showDealerCard();
        //båda fick samma poäng
        winCondition = 'Draw';
        notifyListeners();
      } else if (playerScore > dealerScore) {
        split ? null : showDealerCard();
        //spelaren fick mer poäng
        winCondition = 'Win';
        notifyListeners();
      } else if (playerScore < dealerScore) {
        split ? null : showDealerCard();
        //dealern fick mer poäng
        winCondition = 'Lose';
        notifyListeners();
      } else {
        winCondition = 'NoWinnerYet';
      }
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealerCard();
        //båda har blackjack
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        showDealerCard();
        //dealern har blackjack
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
        //dealern blev tjock
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (dealerScore == playerScore) {
        showDealerCard();
        //båda fick samma poäng
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (playerScore > dealerScore) {
        showDealerCard();
        //spelaren fick mer poäng
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore < dealerScore) {
        showDealerCard();
        //dealern fick mer poäng
        splitWinCondition = 'Lose';
        notifyListeners();
      } else {
        splitWinCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else {
      throw Exception('Didnt choose hand');
    }
  }

  String handCheckToString({required String playerOrSplit}) {
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
    } else {
      playerScore = DeckOfCards().handValue(playerHand);
    }

    if (playerScore == 21) {
      return 'BlackJack!';
    } else if (playerScore > 21) {
      return 'Bust!';
    } else {
      return '';
    }
  }

  bool handCheck({required String playerOrSplit}) {
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(splitHand);
    } else {
      playerScore = DeckOfCards().handValue(playerHand);
    }

    if (playerScore == 21) {
      return true;
    } else if (playerScore > 21) {
      return true;
    } else {
      return false;
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
        showDealerCard();
        //båda har blackjack
        winCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        showDealerCard();
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
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
        showDealerCard();
        //båda har blackjack
        splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        showDealerCard();
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
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

//TODO: ev ta bort static
  static Widget errorHandling(Exception e, BuildContext context) {
    return AlertDialog(
        title: const Text('Something went wrong'),
        content: Text('$e'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ]);
  }
}
