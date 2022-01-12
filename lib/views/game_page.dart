import 'package:flutter/material.dart';
import 'package:my_first_app/models/card_themes.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:my_first_app/views/settings_page.dart';
import 'package:provider/provider.dart';
import '../game_engine/blackjack.dart';
import 'package:playing_cards/playing_cards.dart';
import '../game_engine/error_handling.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'New Game',
                child: Text('New Game'),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'Forfeit',
                child: Text('Forfeit'),
              ),
              const PopupMenuItem<String>(
                value: 'Quit to main menu',
                child: Text('Quit to main menu'),
              ),
            ],
            onSelected: (String choice) {
              switch (choice) {
                //startar ett nytt spel
                case 'New Game':
                  {
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                        .forfeit(context: context);
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                        .setUpNewGame();
                    break;
                  }
                //Går till settings
                case 'Settings':
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ));

                    break;
                  }
                //ger upp och får tillbaka halva insatsen
                case 'Forfeit':
                  {
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                        .forfeit(context: context);

                    break;
                  }
                //går till huvudmenyn samt får tillbaka halva insatsen
                case 'Quit to main menu':
                  {
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                        .forfeit(context: context);
                    Navigator.pop(context);
                    break;
                  }
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30, top: 15),
              child: Consumer(
                builder: (context, state, child) => Text(
                  // hämtar balansen
                  '\$${Provider.of<CardThemeHandler>(context, listen: true).getBalance(context: context)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          _startNewGame(context: context),
          Consumer<BlackJackGameEngine>(
            builder: (context, state, child) => _winOrLosePopUp(
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .getSplit,
                Provider.of<BlackJackGameEngine>(context, listen: true)
                    .getWinCondition,
                Provider.of<BlackJackGameEngine>(context, listen: true)
                    .getSplitWinCondition,
                context: context),
          ),
          // Consumer<BlackJack>(
          //     builder: (context, state, child) => splitOrDouble(
          //         Provider.of<BlackJack>(context, listen: false)
          //             .getCanDoubleOrSplit)),
          Consumer<BlackJackGameEngine>(
              builder: (context, state, child) => _popUpBet(
                  firstRound:
                      Provider.of<BlackJackGameEngine>(context, listen: false)
                          .getCanBet,
                  context: context)),
        ]));
  }

  Widget _startNewGame({required BuildContext context}) {
    //testar dubbling
    Provider.of<BlackJackGameEngine>(context, listen: false)
        .testingDouble(context: context);
    //hämtar balance
    Provider.of<CardThemeHandler>(context, listen: false)
        .fetchBalance(context: context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Provider.of<BlackJackGameEngine>(context, listen: false).getCanBet
            ? const SizedBox.shrink()
            : SizedBox(
                width: 200,
                child: Consumer<BlackJackGameEngine>(
                    builder: (context, state, child) => _getHand(
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getDealerHand,
                        dealer: true,
                        context: context))),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Knappen för att kunna ta ett till kort (hit)
                ElevatedButton(
                  onPressed: () {
                    try {
                      //hämtar split som kollar om du har splittat eller inte
                      if (Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .getSplit &&
                          //hämtar splitturn som kollar om det är splithandens
                          //tur att agera
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getSplitTurn ==
                              false)
                      //om man splittat men det är playerhands tur att agera
                      {
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getNewCard(playerOrSplit: 'Player');
                        //hämtar handcheck som kollar om du blivit bust eller
                        //fått blackjack
                        if (Provider.of<BlackJackGameEngine>(context,
                                listen: false)
                            .handCheck(playerOrSplit: 'Player')) {
                          //om handcheck är true så stannar spelet
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .stop(playerOrDealerOrSplit: 'Player');
                          //kollar om splithanden fått blackjack
                          if (Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .getSplitStop) {
                            Provider.of<BlackJackGameEngine>(context,
                                    listen: false)
                                .dealersTurn();
                          }
                          //sätter splitturn till sant - byter från playerhand till
                          //splithand
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .setSplitTurn = true;
                        }
                      } else if (Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .getSplit &&
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getSplitTurn ==
                              true) {
                        //spelar med splithanden
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getNewCard(playerOrSplit: 'Split');
                        //kollar om splithanden blev tjock eller fick blackjack
                        //blev den tjock stannar den och går vidare till att
                        //spelar med dealern
                        if (Provider.of<BlackJackGameEngine>(context,
                                listen: false)
                            .handCheck(playerOrSplit: 'Split')) {
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .stop(playerOrDealerOrSplit: 'Split');
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .dealersTurn();
                          //kollar om de båda händerna har vunnit eller förlorat
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .winOrLose(playerOrSplit: 'Player');
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .winOrLose(playerOrSplit: 'Split');
                        }
                      }
                      //här är det ingen split utan bara spelarens tur att spela
                      else {
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getNewCard(playerOrSplit: 'Player');
                        if (Provider.of<BlackJackGameEngine>(context,
                                listen: false)
                            .handCheck(playerOrSplit: 'Player')) {
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .stop(playerOrDealerOrSplit: 'Player');
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .dealersTurn();
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .winOrLose(playerOrSplit: 'Player');
                        }
                      }
                    } catch (e) {
                      ErrorHandling().errorHandling(e, context);
                    }
                  },
                  child: const Text('  Hit  '),
                  style: ButtonStyle(
                      backgroundColor:
                          //ändrar färgen på knappen beroende på om du kan 'hitta' mer
                          //eller inte
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getDoubled
                              ? (Provider.of<BlackJackGameEngine>(context,
                                              listen: false)
                                          .getPlayerHand
                                          .length >
                                      2)
                                  ? MaterialStateProperty.all(Colors.grey[700])
                                  : null
                              : null),
                ),
                //skriver ut playerbet
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Playerbet',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                        '\$${Provider.of<BlackJackGameEngine>(context, listen: false).getPlayerBet}',
                        style: const TextStyle(fontSize: 18))
                  ],
                ),
                //standknappen
                Consumer<BlackJackGameEngine>(
                  builder: (context, state, child) => ElevatedButton(
                    onPressed: () {
                      //kollar om du splittat eller inte och om splitturnen
                      //inte är gjord
                      if (Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .getSplit &&
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getSplitTurn ==
                              false) {
                        //stannar spelaren och går över till splithand
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Player');
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .setSplitTurn = true;
                        //är splitstopp true så stannar den och låter
                        //dealern spela
                        if (Provider.of<BlackJackGameEngine>(context,
                                listen: false)
                            .getSplitStop) {
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .dealersTurn();
                        }
                      }
                      //om du har splittat och det är splithandens tur
                      else if (Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .getSplit &&
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getSplitTurn ==
                              true) {
                        //stannar splithandens tur och låter dealern spela
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Split');
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .dealersTurn();
                        //kollar vem som vunnit
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Player');
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Split');
                      } else {
                        //om det inte är en split stannar den playerhand
                        //och jämför vem som vunit
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Player');
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .dealersTurn();
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Player');
                      }
                    },
                    child: const Text('Stand'),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            // ändrar färgen för splitknappen
            //splitknappen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                                .getCanSplit
                            ? null
                            : MaterialStateProperty.all(Colors.grey[700]),
                  ),
                  onPressed: () {
                    if (Provider.of<BlackJackGameEngine>(context, listen: false)
                        .getCanSplit) {
                      try {
                        //gör split och sätter cansplit till false så att det
                        //inte går att splitta
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .doSplit(context: context);
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                            .setCanSplit = false;
                      } catch (e) {
                        ErrorHandling().errorHandling(e, context);
                      }
                    } else {
                      null;
                    }
                  },
                  child: const Text('  Split  '),
                ),
                //visar splitbettet
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //om du gjort en split visas rubrik för bettet, annars inte
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getSplit
                        ? const Text('Splitbet', style: TextStyle(fontSize: 18))
                        : const SizedBox.shrink(),
                    //hämtar värdet för splitbet och skriver ut det
                    Provider.of<BlackJackGameEngine>(context, listen: false)
                            .getSplit
                        ? Text(
                            '\$${Provider.of<BlackJackGameEngine>(context, listen: false).getSplitBet}',
                            style: const TextStyle(fontSize: 18))
                        : const SizedBox.shrink()
                  ],
                ),
                //doubleknappen
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          //kollar om det går att dubbla
                          Provider.of<BlackJackGameEngine>(context,
                                      listen: false)
                                  .getCanDouble
                              ? Provider.of<BlackJackGameEngine>(context,
                                          listen: false)
                                      .checkRound()
                                  ? null
                                  : MaterialStateProperty.all(Colors.grey[700])
                              : MaterialStateProperty.all(Colors.grey[700]),
                    ),
                    onPressed: () {
                      //dubblar om du klickar på knappen
                      if (Provider.of<BlackJackGameEngine>(context,
                              listen: false)
                          .getCanDouble) {
                        try {
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .doDouble(context: context);
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .setCanDouble = false;
                        } on Exception catch (e) {
                          ErrorHandling().errorHandling(e, context);
                        }
                      } else {
                        null;
                      }
                    },
                    child: const Text('Double')),
              ],
            ),
          ],
        ),
        //lägger in en pil över den aktuella handen som vars tur det är
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Provider.of<BlackJackGameEngine>(context, listen: true).getSplit
                ? SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                                .getSplitTurn
                            ? const Icon(Icons.arrow_downward_sharp)
                            : const SizedBox.shrink(),
                        //skriver ut en text om man blir tjock eller får blackjack
                        Text(
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .handCheckToString(playerOrSplit: 'Split'),
                        ),
                        Consumer<BlackJackGameEngine>(
                            builder: (context, state, child) => _getHand(
                                Provider.of<BlackJackGameEngine>(context,
                                        listen: false)
                                    .getSplitHand,
                                dealer: false,
                                context: context))
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            Provider.of<BlackJackGameEngine>(context, listen: false).getCanBet
                ? const SizedBox.shrink()
                : SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        Provider.of<BlackJackGameEngine>(context, listen: false)
                                .getSplitTurn
                            ? const SizedBox.shrink()
                            : const Icon(Icons.arrow_downward_sharp),
                        Text(
                          Provider.of<BlackJackGameEngine>(context,
                                  listen: false)
                              .handCheckToString(playerOrSplit: 'Player'),
                        ),
                        //målar upp vyn för splithand
                        (Consumer<BlackJackGameEngine>(
                            builder: (context, state, child) => _getHand(
                                Provider.of<BlackJackGameEngine>(context,
                                        listen: false)
                                    .getPlayerHand,
                                dealer: false,
                                context: context)))
                      ],
                    ),
                  ),
          ],
        )
      ],
    );
  }

  //genererar vyn för spelaren och dealerns kort
  Widget _getHand(List<PlayingCard> hand,
      {required bool dealer, required BuildContext context}) {
    //hämtar dealercardshown för att kunna bestämma när och om dealern ska visa
    //sina kort (en bool-variabel)
    bool showDealerCard =
        Provider.of<BlackJackGameEngine>(context, listen: false)
            .getDealerCardShown;

    List<Widget> viewHand = <Widget>[];
    for (int i = 0; i < hand.length; i++) {
      viewHand.add(
        SizedBox(
          height: 163,
          width: 126,
          child: PlayingCardView(
              style: Provider.of<CardThemeHandler>(context, listen: false)
                  .getPlayingCardThemeMode,
              card: hand[i],
              elevation: 10,
              showBack: dealer
                  //testar så att dealern gömmer ett av sina kort
                  ? i == 0
                      ? showDealerCard
                          ? false
                          : true
                      : false
                  : false),
        ),
      );
    }
    return FlatCardFan(
        children: viewHand); //flatcardfan låter korten ligga "ovanpå" varandra
  }

  Widget _winOrLosePopUp(
      bool split, String winOrLosePlayer, String winOrLoseSplit,
      {required BuildContext context}) {
    //popup om du vinner eller förlorar där du kan starta en ny runda eller
    // gå till startsidan
    //om man splittat och alla är sanna så avslutas spelet
    if (Provider.of<BlackJackGameEngine>(context, listen: true).getSplit &&
        Provider.of<BlackJackGameEngine>(context, listen: true).getDealerStop &&
        Provider.of<BlackJackGameEngine>(context, listen: true).getPlayerStop &&
        Provider.of<BlackJackGameEngine>(context, listen: true).getSplitStop) {
      if (winOrLosePlayer == 'NoWinnerYet' || winOrLoseSplit == 'NoWinnerYet') {
        return const SizedBox.shrink();
      } else if (winOrLosePlayer == 'Win' && winOrLoseSplit == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won both hands!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  //delar ut vinster för split och playerhand
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  //lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till vinster, förluster och spelade matcher i
                    //firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Win' && winOrLoseSplit == 'Lose') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won the player hand but lost the split!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Win' && winOrLoseSplit == 'Draw') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won the player hand but drew the split!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //delar ut vinster och lägger till dragna kort i firestore
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .setSplitTurn = false;
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .winnings(playerOrSplit: 'Player', context: context);
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .drawBet(playerOrSplit: 'Split', context: context);
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .addCardsToDB(context: context);
                try {
                  //lägger till spelade matcher i firestore
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          context: context,
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                } on Exception catch (e) {
                  ErrorHandling().errorHandling(e, context);
                }
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .setUpNewGame();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      } else if (winOrLosePlayer == 'Lose' && winOrLoseSplit == 'Lose') {
        return AlertDialog(
          title: const Text('Bad luck!'),
          content: const Text('You Lost both hands!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till matcherna i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Lose' && winOrLoseSplit == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You Lost on the playerhand but won the split!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till spelade matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Lose' && winOrLoseSplit == 'Draw') {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You Lost on the playerhand but drew the split!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger till kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .drawBet(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Draw' && winOrLoseSplit == 'Draw') {
        return AlertDialog(
          title: const Text('Draw!'),
          content: const Text('You got the same score as the dealer'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Draw' && winOrLoseSplit == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You drew the playerhand but won the split!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och och lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Draw' && winOrLoseSplit == 'Lose') {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You drew the playerhand but lost the split!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger till kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
      //kollar om du vunnit eller förlorat när du inte har splittat
    } else if (!Provider.of<BlackJackGameEngine>(context, listen: true)
            .getSplit &&
        Provider.of<BlackJackGameEngine>(context, listen: true).getDealerStop &&
        Provider.of<BlackJackGameEngine>(context, listen: true).getPlayerStop) {
      if (winOrLosePlayer == 'NoWinnerYet') {
        return const SizedBox.shrink();
      } else if (winOrLosePlayer == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won the hand!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //delar ut vinster och lägger dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till spelade matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Lose') {
        return AlertDialog(
          title: const Text('Bad luck!'),
          content: const Text('You Lost the round'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  //lägger till dragna kort i firestore
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setSplitTurn = false;
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .addCardsToDB(context: context);
                  try {
                    //lägger till spelade matcher i firestore
                    Provider.of<FirestoreImplementation>(context, listen: false)
                        .incrementGameCountAndWinOrLose(
                            context: context,
                            split: split,
                            splitWinOrLose: winOrLoseSplit,
                            winOrLose: winOrLosePlayer,
                            userId: Provider.of<FirebaseAuthImplementation>(
                                    context,
                                    listen: false)
                                .getUserId()!);
                  } on Exception catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                  Provider.of<BlackJackGameEngine>(context, listen: false)
                      .setUpNewGame();
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Draw') {
        return AlertDialog(
          title: const Text('Draw!'),
          content: const Text('You got the same score as the dealer'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //delar ut vinster lägger till dragna kort i firestore
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .setSplitTurn = false;
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .drawBet(playerOrSplit: 'Player', context: context);
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .addCardsToDB(context: context);
                try {
                  //lägger till spelade matcher i firestore
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          context: context,
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                } on Exception catch (e) {
                  ErrorHandling().errorHandling(e, context);
                }
                Provider.of<BlackJackGameEngine>(context, listen: false)
                    .setUpNewGame();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _popUpBet({required bool firstRound, required BuildContext context}) {
    Provider.of<CardThemeHandler>(context, listen: false)
        .fetchBalance(context: context);

    if (firstRound &&
        Provider.of<CardThemeHandler>(context, listen: false)
                .getBalance(context: context) !=
            0) {
      return AlertDialog(
        title: const Text('Time to place your bet'),
        content: const Text('Choose your amount'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //ökar bettet med 25 kollar om du kan splitta
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .increaseBet(bet: 25, context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .testingSplit(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .setCanBet = false;
            },
            child: const Text('25'),
          ),
          TextButton(
            onPressed: () {
              //ökar bettet med 50 kollar om du kan splitta
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .increaseBet(bet: 50, context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .testingSplit(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .setCanBet = false;
            },
            child: const Text('50'),
          ),
          TextButton(
            onPressed: () {
              //ökar bettet med 100 kollar om du kan splitta
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .increaseBet(bet: 100, context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .testingSplit(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .setCanBet = false;
            },
            child: const Text('100'),
          ),
          TextButton(
            onPressed: () {
              //går all in och testar split
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .allIn(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .testingSplit(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .setCanBet = false;
            },
            child: const Text('All in'),
          ),
        ],
      );
    } else if (firstRound &&
        Provider.of<CardThemeHandler>(context, listen: false)
                .getBalance(context: context) ==
            0) {
      return AlertDialog(
        title: const Text('Out of cash'),
        content: const Text('You can play without betting'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .testingSplit(context: context);
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .setCanBet = false;
            },
            child: const Text('Play without bet'),
          ),
          TextButton(
            onPressed: () {
              //avslutar spelet och ger tillbaka halva bettet
              Provider.of<BlackJackGameEngine>(context, listen: false)
                  .forfeit(context: context);
              Navigator.pop(context);
            },
            child: const Text('Quit'),
          ),
        ],
      );
    } else if (!firstRound) {
      return const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }
}
