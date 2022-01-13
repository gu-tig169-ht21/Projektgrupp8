import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/models/card_themes.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import 'deck_of_cards.dart';
import '../game_engine/error_handling.dart';

class BlackJackGameEngine extends ChangeNotifier {
  List<PlayingCard> _deck = standardFiftyTwoCardDeck();
  List<PlayingCard> _playerHand = <PlayingCard>[];
  List<PlayingCard> _splitHand = <PlayingCard>[];
  List<PlayingCard> _dealerHand = <PlayingCard>[];
  bool _dealerStop = false;
  bool _playerStop = false;
  bool _splitStop = false;
  int _playerBet = 0;
  int _splitBet = 0;
  bool _doubled = false;
  bool _split = false;
  bool _splitTurn = false;
  String _winCondition = 'NoWinnerYet';
  String _splitWinCondition = 'NoWinnerYet';
  bool _dealerCardShown = false;
  bool _canBet = true;
  bool _canSplit = true;
  bool _canDouble = true;
  int _rounds = 1;
  int _numberOfDecks = 1;

  BlackJackGameEngine() {
    //funktioner som görs vid första instansiering
    resetDeck();

    clearHands();

    startingHands();
  }

  bool get getDoubled {
    return _doubled;
  }

  bool get getPlayerStop {
    return _playerStop;
  }

  bool get getSplitStop {
    return _splitStop;
  }

  bool get getDealerStop {
    return _dealerStop;
  }

  int get getRounds {
    return _rounds;
  }

  bool get getCanDouble {
    return _canDouble;
  }

  bool get getCanSplit {
    return _canSplit;
  }

  String get getSplitWinCondition {
    return _splitWinCondition;
  }

  bool get getSplit {
    return _split;
  }

  int get getSplitBet {
    return _splitBet;
  }

  bool get getCanBet {
    return _canBet;
  }

  String get getWinCondition {
    return _winCondition;
  }

  List<PlayingCard> get getPlayerHand {
    return _playerHand;
  }

  List<PlayingCard> get getSplitHand {
    return _splitHand;
  }

  List<PlayingCard> get getDealerHand {
    return _dealerHand;
  }

  bool get getDealerCardShown {
    return _dealerCardShown;
  }

  int get getPlayerBet {
    return _playerBet;
  }

  bool get getSplitTurn {
    return _splitTurn;
  }

  set setSplitTurn(bool value) {
    _splitTurn = value;
    notifyListeners();
  }

  set setCanBet(bool value) {
    _canBet = value;
    notifyListeners();
  }

  set setCanSplit(bool value) {
    _canSplit = value;
    notifyListeners();
  }

  set setCanDouble(bool value) {
    _canDouble = value;
    notifyListeners();
  }

  void subtractFromBalance(
      {required int i, required BuildContext context}) async {
    try {
      await Provider.of<FirestoreImplementation>(context, listen: false)
          .changeBalance(
              context: context,
              userId: Provider.of<FirebaseAuthImplementation>(context,
                      listen: false)
                  .getUserId()!,
              change: i,
              add: false);
      notifyListeners();
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

//adderar lekar
  void addDecks(String a) {
    int decks = int.parse(a);
    if (decks == 1) {
      _deck.clear();
      _deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 2) {
      _deck.clear();
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 3) {
      _deck.clear();
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 4) {
      _deck.clear();
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
    } else if (decks == 5) {
      _deck.clear();
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
      _deck.addAll(standardFiftyTwoCardDeck());
    } else {
      _deck = standardFiftyTwoCardDeck();
    }
    _numberOfDecks = decks;
  }

  void setUpNewGame() {
    //resettar alla variabler till defaultvärdet och drar nya kort
    addDecks('$_numberOfDecks');
    clearHands();
    _playerBet = 0;
    _splitBet = 0;
    _dealerStop = false;
    _splitStop = false;
    _playerStop = false;
    _doubled = false;
    _split = false;
    _winCondition = 'NoWinnerYet';
    _splitWinCondition = 'NoWinnerYet';
    _dealerCardShown = false;
    _canDouble = true;
    _canSplit = true;
    setCanBet = true;
    _rounds = 1;
    startingHands();
    notifyListeners();
  }

  void forfeit({required BuildContext context}) async {
    await Provider.of<FirestoreImplementation>(context, listen: false)
        .changeBalance(
            context: context,
            userId:
                Provider.of<FirebaseAuthImplementation>(context, listen: false)
                    .getUserId()!,
            change: _playerBet ~/ 2,
            add: true);
    setUpNewGame();
    notifyListeners();
  }

  bool checkRound() {
    if (_rounds == 1) {
      return true;
    } else {
      return false;
    }
  }

  void incrementRounds() {
    _rounds++;
  }

  void showDealerCard() {
    //ändrar dealerCardsShown till true
    _dealerCardShown = true;
    notifyListeners();
  }

  void clearHands() {
    //tar bort kort från spelarnas händer
    _playerHand.clear();
    _dealerHand.clear();
    _splitHand.clear();
    notifyListeners();
  }

  void startingHands() {
    //drar de första korten för dealer och spelaren
    PlayingCard card = DeckOfCards().pickACard(_deck);

    _playerHand.add(card);
    _deck.removeWhere((element) => element == card);

    card = DeckOfCards().pickACard(_deck);
    _dealerHand.add(card);
    _deck.removeWhere((element) => element == card);

    card = DeckOfCards().pickACard(_deck);
    _playerHand.add(card);
    _deck.removeWhere((element) => element == card);

    card = DeckOfCards().pickACard(_deck);
    _dealerHand.add(card);
    _deck.removeWhere((element) => element == card);

    if (handCheck(playerOrSplit: 'Player')) {
      stop(playerOrDealerOrSplit: 'Player');
      dealersTurn();
      winOrLose(playerOrSplit: 'Player');
    }

    notifyListeners();
  }

  void resetDeck() {
    //resettar kortleken
    _deck = standardFiftyTwoCardDeck();
    notifyListeners();
  }

  void dealersTurn() {
    //funktionen för dealerns tur
    PlayingCard card;
    showDealerCard();
    //dealern drar kort till summan är över 17
    while (DeckOfCards().handValue(_dealerHand) < 17) {
      card = DeckOfCards().pickACard(_deck);
      _dealerHand.add(card);
      _deck.removeWhere((element) => element == card);
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
          _playerStop = true;
          notifyListeners();
          break;
        }
      case 'Dealer':
        {
          _dealerStop = true;
          notifyListeners();
          break;
        }
      case 'Split':
        {
          _splitStop = true;
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
    if (playerOrSplit == 'Player') {
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _playerBet * 2,
                add: true);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
    } else if (playerOrSplit == 'Split') {
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _playerBet * 2,
                add: true);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void drawBet(
      {required String playerOrSplit, required BuildContext context}) async {
    //ger tillbaka dina pengar om du får en draw med dealern
    if (playerOrSplit == 'Player') {
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _playerBet,
                add: true);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
    } else if (playerOrSplit == 'Split') {
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _playerBet,
                add: true);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }

      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
    } else {
      throw Exception('Player or split not assigned');
    }
  }

  void increaseBet({required int bet, required BuildContext context}) async {
    int balance = 0;
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    //returna det nya bettet istället
    //ökar spelarens insats
    if (bet <= balance) {
      _playerBet += bet;
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: bet,
                add: false);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else if (bet > balance) {
      throw Exception('Not enough money');
    } else {
      throw Exception('Something went wrong setting bet');
    }
  }

  void allIn({required BuildContext context}) async {
    int balance = 0;
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    if (balance > 0) {
      _playerBet = balance;
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: balance,
                add: false);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else if (balance <= 0) {
      throw Exception('Not enough money to go all in');
    } else {
      throw Exception('Something went wrong going all in');
    }
  }

  void addCardsToDB({required BuildContext context}) {
    for (PlayingCard card in _playerHand) {
      try {
        Provider.of<FirestoreImplementation>(context, listen: false)
            .incrementCardInDB(
                context: context,
                card: card,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
    }
    if (_split) {
      for (PlayingCard card in _splitHand) {
        try {
          Provider.of<FirestoreImplementation>(context, listen: false)
              .incrementCardInDB(
                  context: context,
                  card: card,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
        } on Exception catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    }
  }

  void getNewCard({required String playerOrSplit}) {
    incrementRounds();
    //drar ett nytt kort för spelaren
    switch (playerOrSplit) {
      case 'Player':
        {
          PlayingCard card = DeckOfCards().pickACard(_deck);
          if (!_doubled) {
            _playerHand.add(card);
            _deck.removeWhere((element) => element == card);
            notifyListeners();
          } else if (_doubled && _playerHand.length < 3) {
            _playerHand.add(card);
            _deck.removeWhere((element) => element == card);
            notifyListeners();
          } else {
            throw Exception('Cant pick new card');
          }
          break;
        }
      case 'Split':
        {
          PlayingCard card = DeckOfCards().pickACard(_deck);
          _splitHand.add(card);
          _deck.removeWhere((element) => element == card);
          notifyListeners();
          break;
        }
      default:
        {
          break;
        }
    }
  }

//testar om det går att dubbla
  void testingDouble({required BuildContext context}) async {
    int balance = 0;
    //hämtar balance hos det inloggade UserID:t
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    //jämför balance med ditt bet vilket avgör om det går att dubbla eller ej
    if (balance >= _playerBet) {
      _canDouble = true;
      notifyListeners();
    } else {
      _canDouble = false;
      notifyListeners();
    }
  }

  void doDouble({required BuildContext context}) async {
    incrementRounds();
    //en dubblering av insatsen
    int balance = 0;
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    if (balance >= _playerBet) {
      try {
        //minskar balance med värdet för playerbet
        Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _playerBet,
                add: false);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      //dubblar bettet
      _playerBet = _playerBet * 2;
      _doubled = true;
      //uppdaterar balance
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
      notifyListeners();
    } else {
      _canDouble = false;
      notifyListeners();
    }
  }

  void testingSplit({required BuildContext context}) async {
    int balance = 0;
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    if (_playerHand[0].value == _playerHand[1].value &&
        balance >= _playerBet &&
        _rounds == 1) {
      _canSplit = true;
      notifyListeners();
    } else {
      _canSplit = false;
      notifyListeners();
    }
  }

  void doSplit({required BuildContext context}) async {
    int balance = 0;
    try {
      balance =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getBalance(
                  context: context,
                  userId: Provider.of<FirebaseAuthImplementation>(context,
                          listen: false)
                      .getUserId()!);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    //gör en split om det väljs och kraven uppfylls
    PlayingCard card = DeckOfCards().pickACard(_deck);
    if (_playerHand[0].value == _playerHand[1].value &&
        balance >= _playerBet &&
        _rounds == 1) {
      _splitHand.add(_playerHand[1]);
      _playerHand.removeAt(1);

      _splitBet = _playerBet;
      try {
        await Provider.of<FirestoreImplementation>(context, listen: false)
            .changeBalance(
                context: context,
                userId: Provider.of<FirebaseAuthImplementation>(context,
                        listen: false)
                    .getUserId()!,
                change: _splitBet,
                add: false);
      } on Exception catch (e) {
        ErrorHandling().errorHandling(e, context);
      }
      Provider.of<CardThemeHandler>(context, listen: false)
          .fetchBalance(context: context);
      _playerHand.add(card);
      _deck.removeWhere((element) => element == card);
      card = DeckOfCards().pickACard(_deck);
      _splitHand.add(card);
      _deck.removeWhere((element) => element == card);
      _split = true;
      //kollar båda av händerna har fått blackjack eller inte
      //har de det så stannar den och låter dealern spela
      //samt kollar vem/vilka som vunnit
      if (handCheck(playerOrSplit: 'Player') &&
          handCheck(playerOrSplit: 'Split')) {
        stop(playerOrDealerOrSplit: 'Player');
        stop(playerOrDealerOrSplit: 'Split');
        dealersTurn();
        winOrLose(playerOrSplit: 'Player');
        winOrLose(playerOrSplit: 'Split');
      }
      //kollar om playerhand fått blackjack
      //kollar isåfall winorlose och sätter splitturn till true
      else if (handCheck(playerOrSplit: 'Player')) {
        stop(playerOrDealerOrSplit: 'Player');
        winOrLose(playerOrSplit: 'Player');
        setSplitTurn = true;
      } else if (handCheck(playerOrSplit: 'Split')) {
        stop(playerOrDealerOrSplit: 'Split');
        winOrLose(playerOrSplit: 'Split');
      }

      notifyListeners();
    } else {
      _canSplit = false;
      notifyListeners();
    }
    //ökar värdet på rounds med 1
    incrementRounds();
  }

  //kollar om man vunnit, förlorat eller spelat lika
  void winOrLose({required String playerOrSplit}) {
    //kalla en gång, eller två vid en split
    int dealerScore = DeckOfCards().handValue(_dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(_playerHand);
      if (dealerScore == 21 && playerScore == 21) {
        //gör så att dealern inte visar sina kort innan båda händerna stannat
        //vid en eventuellt split
        _split ? null : showDealerCard();
        //båda har blackjack
        _winCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        _split ? null : showDealerCard();
        //dealern har blackjack
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        _split ? null : showDealerCard();
        //spelaren har blackjack
        _winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        _split ? null : showDealerCard();
        //spelaren blev tjock
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        _split ? null : showDealerCard();
        //dealern blev tjock
        _winCondition = 'Win';
        notifyListeners();
      } else if (dealerScore == playerScore) {
        _split ? null : showDealerCard();
        //båda fick samma poäng
        _winCondition = 'Draw';
        notifyListeners();
      } else if (playerScore > dealerScore) {
        _split ? null : showDealerCard();
        //spelaren fick mer poäng
        _winCondition = 'Win';
        notifyListeners();
      } else if (playerScore < dealerScore) {
        _split ? null : showDealerCard();
        //dealern fick mer poäng
        _winCondition = 'Lose';
        notifyListeners();
      } else {
        _winCondition = 'NoWinnerYet';
      }
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(_splitHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealerCard();
        //båda har blackjack
        _splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        showDealerCard();
        //dealern har blackjack
        _splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        _splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        _splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
        //dealern blev tjock
        _splitWinCondition = 'Win';
        notifyListeners();
      } else if (dealerScore == playerScore) {
        showDealerCard();
        //båda fick samma poäng
        _splitWinCondition = 'Draw';
        notifyListeners();
      } else if (playerScore > dealerScore) {
        showDealerCard();
        //spelaren fick mer poäng
        _splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore < dealerScore) {
        showDealerCard();
        //dealern fick mer poäng
        _splitWinCondition = 'Lose';
        notifyListeners();
      } else {
        _splitWinCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else {
      throw Exception('Didnt choose hand');
    }
  }

  String handCheckToString({required String playerOrSplit}) {
    int playerScore;
    if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(_playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(_splitHand);
    } else {
      playerScore = DeckOfCards().handValue(_playerHand);
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
      playerScore = DeckOfCards().handValue(_playerHand);
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(_splitHand);
    } else {
      playerScore = DeckOfCards().handValue(_playerHand);
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
    int dealerScore = DeckOfCards().handValue(_dealerHand);
    int playerScore;
    if (playerOrSplit == 'Player' && _split) {
      playerScore = DeckOfCards().handValue(_playerHand);
      if (dealerScore == 21 && playerScore == 21) {
        //båda har blackjack
        _winCondition = 'Draw';
        stop(playerOrDealerOrSplit: 'Player');
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        stop(playerOrDealerOrSplit: 'Player');
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        //spelaren har blackjack
        stop(playerOrDealerOrSplit: 'Player');
        _winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        //spelaren blev tjock
        stop(playerOrDealerOrSplit: 'Player');
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        //dealern blev tjock
        stop(playerOrDealerOrSplit: 'Player');
        _winCondition = 'Win';
        notifyListeners();
      } else {
        _winCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else if (playerOrSplit == 'Player') {
      playerScore = DeckOfCards().handValue(_playerHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealerCard();
        //båda har blackjack
        _winCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        showDealerCard();
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        _winCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        _winCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
        //dealern blev tjock
        _winCondition = 'Win';
        notifyListeners();
      } else {
        _winCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else if (playerOrSplit == 'Split') {
      playerScore = DeckOfCards().handValue(_splitHand);
      if (dealerScore == 21 && playerScore == 21) {
        showDealerCard();
        //båda har blackjack
        _splitWinCondition = 'Draw';
        notifyListeners();
      } else if (dealerScore == 21 && playerScore != 21) {
        //dealern har blackjack
        showDealerCard();
        _splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore != 21 && playerScore == 21) {
        showDealerCard();
        //spelaren har blackjack
        _splitWinCondition = 'Win';
        notifyListeners();
      } else if (playerScore > 21) {
        showDealerCard();
        //spelaren blev tjock
        _splitWinCondition = 'Lose';
        notifyListeners();
      } else if (dealerScore > 21) {
        showDealerCard();
        //dealern blev tjock
        _splitWinCondition = 'Win';
        notifyListeners();
      } else {
        _splitWinCondition = 'NoWinnerYet';
        notifyListeners();
      }
    } else {
      throw Exception('Didnt choose hand');
    }
  }
}
