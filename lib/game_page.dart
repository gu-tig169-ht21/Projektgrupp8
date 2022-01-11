import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:my_first_app/card_themes.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:my_first_app/settings_page.dart';
import 'package:provider/provider.dart';
import 'blackjack.dart';
import 'package:playing_cards/playing_cards.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //kolla läget
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
                case 'New Game':
                  {
                    //startar ett nytt spel
                    break;
                  }
                case 'Settings':
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Settings(),
                        ));

                    break;
                  }
                case 'Forfeit':
                  {
                    Provider.of<BlackJack>(context, listen: false).forfeit(context: context);

                    break;
                  }
                case 'Quit to main menu':
                  {
                    Provider.of<BlackJack>(context, listen: false).forfeit(context: context);
                    Navigator.pop(context);
                    break;
                  }
              }
            },
          ),
          actions: [
            Consumer(
                builder: (context, state, child) => Text(
                    '${Provider.of<PlayingCardsProvider>(context, listen: true).getBalance(context: context)}'))
          ],
        ),
        body: Stack(children: [
          startNewGame(context: context),
          Consumer<BlackJack>(
            builder: (context, state, child) => winOrLosePopUp(
                Provider.of<BlackJack>(context, listen: false).getSplit,
                Provider.of<BlackJack>(context, listen: true).getWinCondition,
                Provider.of<BlackJack>(context, listen: true)
                    .getSplitWinCondition,
                context: context),
          ),
          // Consumer<BlackJack>(
          //     builder: (context, state, child) => splitOrDouble(
          //         Provider.of<BlackJack>(context, listen: false)
          //             .getCanDoubleOrSplit)),
          Consumer<BlackJack>(
              builder: (context, state, child) => popUpBet(
                  firstRound:
                      Provider.of<BlackJack>(context, listen: false).getCanBet,
                  context: context)),
        ]));
  }

  Widget startNewGame({required BuildContext context}) {
    //här skapas ett nytt spel och startkort delas ut, ska kanske ha något med bet att göra
    Provider.of<PlayingCardsProvider>(context, listen: false).fetchBalance(context: context);

    return Column(
      //när spelaren tryckt på knapp så får dealrn sin tur FIXA
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Provider.of<BlackJack>(context, listen: false).getCanBet
            ? const SizedBox.shrink()
            : SizedBox(
                width: 200,
                child: Consumer<BlackJack>(
                    builder: (context, state, child) => getHand(
                        Provider.of<BlackJack>(context, listen: false)
                            .getDealerHand,
                        dealer: true,
                        context: context))),
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  try {
                    if (Provider.of<BlackJack>(context, listen: false)
                            .getSplit &&
                        Provider.of<BlackJack>(context, listen: false)
                                .getSplitTurn ==
                            false) {
                      Provider.of<BlackJack>(context, listen: false)
                          .getNewCard(playerOrSplit: 'Player');
                      //Provider.of<BlackJack>(context, listen: false)
                      //    .blackJackOrBustCheck(playerOrSplit: 'Player');
                      if (Provider.of<BlackJack>(context, listen: false)
                          .handCheck(playerOrSplit: 'Player')) {
                        Provider.of<BlackJack>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Player');
                        if (Provider.of<BlackJack>(context, listen: false)
                            .getSplitStop) {
                          Provider.of<BlackJack>(context, listen: false)
                              .dealersTurn();
                        }
                        Provider.of<BlackJack>(context, listen: false)
                            .setSplitTurn = true;
                      }
                    } else if (Provider.of<BlackJack>(context, listen: false)
                            .getSplit &&
                        Provider.of<BlackJack>(context, listen: false)
                                .getSplitTurn ==
                            true) {
                      Provider.of<BlackJack>(context, listen: false)
                          .getNewCard(playerOrSplit: 'Split');
                      //Provider.of<BlackJack>(context, listen: false)
                      //    .blackJackOrBustCheck(playerOrSplit: 'Split');
                      if (Provider.of<BlackJack>(context, listen: false)
                          .handCheck(playerOrSplit: 'Split')) {
                        Provider.of<BlackJack>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Split');
                        Provider.of<BlackJack>(context, listen: false)
                            .dealersTurn();
                        Provider.of<BlackJack>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Player');
                        Provider.of<BlackJack>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Split');
                      }
                    } else {
                      Provider.of<BlackJack>(context, listen: false)
                          .getNewCard(playerOrSplit: 'Player');

                      if (Provider.of<BlackJack>(context, listen: false)
                          .handCheck(playerOrSplit: 'Player')) {
                        Provider.of<BlackJack>(context, listen: false)
                            .stop(playerOrDealerOrSplit: 'Player');
                        Provider.of<BlackJack>(context, listen: false)
                            .dealersTurn();
                        Provider.of<BlackJack>(context, listen: false)
                            .winOrLose(playerOrSplit: 'Player');
                      }
                      ;
                    }
                  } catch (e) {
                    //gör en popup som säger att du inte kan dra kort FIXA
                  }
                },
                child: const Text('  Hit  '),
              ),
              Column(
                children: [
                  const Icon(Icons.money, size: 50),
                  Consumer(
                    builder: (context, state, child) => Text(
                        '${Provider.of<BlackJack>(context, listen: true).getPlayerBet}'),
                  ),
                ],
              ),
              Consumer<BlackJack>(
                  builder: (context, state, child) => ElevatedButton(
                      onPressed: () {
                        if (Provider.of<BlackJack>(context, listen: false)
                                .getSplit &&
                            Provider.of<BlackJack>(context, listen: false)
                                    .getSplitTurn ==
                                false) {
                          Provider.of<BlackJack>(context, listen: false)
                              .stop(playerOrDealerOrSplit: 'Player');
                          Provider.of<BlackJack>(context, listen: false)
                              .setSplitTurn = true;
                          if (Provider.of<BlackJack>(context, listen: false)
                              .getSplitStop) {
                            print('dealers turn splitstop');
                            Provider.of<BlackJack>(context, listen: false)
                                .dealersTurn();
                          }
                        } else if (Provider.of<BlackJack>(context,
                                    listen: false)
                                .getSplit &&
                            Provider.of<BlackJack>(context, listen: false)
                                    .getSplitTurn ==
                                true) {
                          Provider.of<BlackJack>(context, listen: false)
                              .stop(playerOrDealerOrSplit: 'Split');
                          Provider.of<BlackJack>(context, listen: false)
                              .dealersTurn();
                          Provider.of<BlackJack>(context, listen: false)
                              .winOrLose(playerOrSplit: 'Player');
                          Provider.of<BlackJack>(context, listen: false)
                              .winOrLose(playerOrSplit: 'Split');
                        } else {
                          Provider.of<BlackJack>(context, listen: false)
                              .stop(playerOrDealerOrSplit: 'Player');
                          Provider.of<BlackJack>(context, listen: false)
                              .dealersTurn();
                          Provider.of<BlackJack>(context, listen: false)
                              .winOrLose(playerOrSplit: 'Player');
                        }
                      },
                      child: const Text('Stand'))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        Provider.of<BlackJack>(context, listen: false)
                                .getCanSplit
                            ? null
                            : MaterialStateProperty.all(Colors.grey),
                  ),
                  onPressed: () {
                    if (Provider.of<BlackJack>(context, listen: false)
                        .getCanSplit) {
                      try {
                        Provider.of<BlackJack>(context, listen: false)
                            .doSplit(context: context);
                        Provider.of<BlackJack>(context, listen: false)
                            .setCanSplit = false;
                      } catch (e) {
                        //FIXA POPUP OM DU INTE KAN SPLITTA!!!!!!!!!!!!!!!!!!!!!!!!!!
                      }
                    } else {
                      null;
                    }
                  },
                  child: const Text('  Split  ')),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        Provider.of<BlackJack>(context, listen: false)
                                .getCanDouble
                            ? Provider.of<BlackJack>(context, listen: false)
                                    .checkRound()
                                ? null
                                : MaterialStateProperty.all(Colors.grey)
                            : MaterialStateProperty.all(Colors.grey),
                  ),
                  onPressed: () {
                    if (Provider.of<BlackJack>(context, listen: false)
                        .getCanDouble) {
                      try {
                        Provider.of<BlackJack>(context, listen: false)
                            .doDouble(context: context);
                        Provider.of<BlackJack>(context, listen: false)
                            .setCanDouble = false;

                        //FIXA POPUP OM DU INTE KAN DUBBLA!!!!!!!!!!!!!!!!!!!!!!!!!!
                      } catch (e) {}
                    } else {
                      null;
                    }
                  },
                  child: const Text('Double')),
            ],
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Provider.of<BlackJack>(context, listen: true).getSplit
              ? SizedBox(
                  width: 200,
                  child: Column(children: [
                    Provider.of<BlackJack>(context, listen: false).getSplitTurn
                        ? const Icon(Icons.arrow_downward_sharp)
                        : const SizedBox.shrink(),
                    Text(Provider.of<BlackJack>(context, listen: false)
                        .handCheckToString(playerOrSplit: 'Split')),
                    Consumer<BlackJack>(
                        builder: (context, state, child) => getHand(
                            Provider.of<BlackJack>(context, listen: false)
                                .getSplitHand,
                            dealer: false,
                            context: context))
                  ]))
              : const SizedBox.shrink(),
          Provider.of<BlackJack>(context, listen: false).getCanBet
              ? const SizedBox.shrink()
              : SizedBox(
                  width: 200,
                  child: Column(children: [
                    Provider.of<BlackJack>(context, listen: false).getSplitTurn
                        ? const SizedBox.shrink()
                        : const Icon(Icons.arrow_downward_sharp),
                    Text(Provider.of<BlackJack>(context, listen: false)
                        .handCheckToString(playerOrSplit: 'Player')),
                    (Consumer<BlackJack>(
                        builder: (context, state, child) => getHand(
                            Provider.of<BlackJack>(context, listen: false)
                                .getPlayerHand,
                            dealer: false,
                            context: context)))
                  ])),
        ])
      ],
    );
  }

  Widget getHand(List<PlayingCard> hand,
      {required bool dealer, required BuildContext context}) {
    //genererar vyn för spelaren och dealerns kort
    //ska dealern även visa kort om du blir tjock eller får blackjack utan att den tar en tur

    bool showDealerCard =
        Provider.of<BlackJack>(context, listen: false).getDealerCardShown;

    List<Widget> viewHand = <Widget>[];
    for (int i = 0; i < hand.length; i++) {
      viewHand.add(SizedBox(
          height: 163,
          width: 126,
          child: PlayingCardView(
              style: Provider.of<PlayingCardsProvider>(context, listen: false)
                  .getPlayingcardThemeMode,
              card: hand[i],
              elevation: 10,
              showBack: dealer
                  ? i == 0
                      ? showDealerCard
                          ? false
                          : true
                      : false
                  : false)));
    }
    return FlatCardFan(
        children: viewHand); //flatcardfan låter korten ligga "ovanpå" varandra
  }

  Widget winOrLosePopUp(
      bool split, String winOrLosePlayer, String winOrLoseSplit,
      {required BuildContext context}) {
    //popup om du vinner eller förlorar där du kan starta en ny runda eller gå till startsidan?
    if (Provider.of<BlackJack>(context, listen: true).getSplit &&
        Provider.of<BlackJack>(context, listen: true).getDealerStop &&
        Provider.of<BlackJack>(context, listen: true).getPlayerStop &&
        Provider.of<BlackJack>(context, listen: true).getSplitStop) {
      if (winOrLosePlayer == 'NoWinnerYet' || winOrLoseSplit == 'NoWinnerYet') {
        return const SizedBox.shrink();
      } else if (winOrLosePlayer == 'Win' && winOrLoseSplit == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won both hands!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
                },
                child: const Text('Ok'))
          ],
        );
      } else if (winOrLosePlayer == 'Lose' && winOrLoseSplit == 'Lose') {
        return AlertDialog(
          title: const Text('Bad luck!'),
          content: const Text('You Lost both hands!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
                },
                child: const Text('Ok'))
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    } else if (!Provider.of<BlackJack>(context, listen: true).getSplit &&
        Provider.of<BlackJack>(context, listen: true).getDealerStop &&
        Provider.of<BlackJack>(context, listen: true).getPlayerStop) {
      if (winOrLosePlayer == 'NoWinnerYet') {
        return const SizedBox.shrink();
      } else if (winOrLosePlayer == 'Win') {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const Text('You Won the hand!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .winnings(playerOrSplit: 'Split', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
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
                  Provider.of<BlackJack>(context, listen: false).setSplitTurn =
                      false;
                  Provider.of<BlackJack>(context, listen: false)
                      .drawBet(playerOrSplit: 'Player', context: context);
                  Provider.of<BlackJack>(context, listen: false)
                      .addCardsToDB(context: context);
                  Provider.of<FirestoreImplementation>(context, listen: false)
                      .incrementGameCountAndWinOrLose(
                          split: split,
                          splitWinOrLose: winOrLoseSplit,
                          winOrLose: winOrLosePlayer,
                          userId: Provider.of<FirebaseAuthImplementation>(
                                  context,
                                  listen: false)
                              .getUserId()!);
                  Provider.of<BlackJack>(context, listen: false).setUpNewGame();
                  //lägg till förändringar till saldo samt bet här
                },
                child: const Text('Ok'))
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget popUpBet({required bool firstRound, required BuildContext context}) {
    Provider.of<PlayingCardsProvider>(context, listen: false).fetchBalance(context: context);

    if (firstRound &&
        Provider.of<PlayingCardsProvider>(context, listen: false).getBalance(context: context) != 0) {
      return AlertDialog(
        title: const Text('Time to place your bet'),
        content: const Text('Choose your amount'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).increaseBet(bet: 25, context: context);
              Provider.of<BlackJack>(context, listen: false).testingSplit(context: context);
              Provider.of<BlackJack>(context, listen: false).testingDouble(context: context);
              Provider.of<BlackJack>(context, listen: false).setCanBet = false;
            },
            child: const Text('25'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).increaseBet(bet: 50, context: context);
              Provider.of<BlackJack>(context, listen: false).testingSplit(context: context);
              Provider.of<BlackJack>(context, listen: false).testingDouble(context: context);
              Provider.of<BlackJack>(context, listen: false).setCanBet = false;
            },
            child: const Text('50'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).increaseBet(bet: 100, context: context);
              Provider.of<BlackJack>(context, listen: false).testingSplit(context: context);
              Provider.of<BlackJack>(context, listen: false).testingDouble(context: context);
              Provider.of<BlackJack>(context, listen: false).setCanBet = false;
            },
            child: const Text('100'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).allIn(context: context);
              Provider.of<BlackJack>(context, listen: false).testingSplit(context: context);
              Provider.of<BlackJack>(context, listen: false).testingDouble(context: context);
              Provider.of<BlackJack>(context, listen: false).setCanBet = false;
            },
            child: const Text('All in'),
          ),
        ],
      );
    } else if (firstRound &&
        Provider.of<PlayingCardsProvider>(context, listen: false).getBalance(context: context) == 0) {
      return AlertDialog(
        title: const Text('Out of cash'),
        content: const Text('You can play without betting'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).testingSplit(context: context);
              Provider.of<BlackJack>(context, listen: false).testingDouble(context: context);
              Provider.of<BlackJack>(context, listen: false).setCanBet = false;
            },
            child: const Text('Play without bet'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<BlackJack>(context, listen: false).forfeit(context: context);
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
