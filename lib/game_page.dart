import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blackjack.dart';
import 'package:playing_cards/playing_cards.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool showDealerCard = false;

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
                    //ska ta dig till inställningssidan
                    break;
                  }
                case 'Forfeit':
                  {
                    //du ger upp, får tillbaka halva insatsen
                    break;
                  }
                case 'Quit to main menu':
                  {
                    //forfeitar och quittar till main
                    Navigator.pop(context);
                    break;
                  }
              }
            },
          ),
        ),
        body: startNewGame());
  }

  Widget startNewGame() {
    //här skapas ett nytt spel och startkort delas ut, ska kanske ha något med bet att göra
    return Column(
      //när spelaren tryckt på knapp så får dealrn sin tur FIXA
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<BlackJack>(
            builder: (context, state, child) => winOrLosePopUp(
                Provider.of<BlackJack>(context, listen: false)
                    .getWinCondition)),
        SizedBox(
            width: 200,
            child: Consumer<BlackJack>(
                builder: (context, state, child) => getHand(
                    Provider.of<BlackJack>(context, listen: false)
                        .getDealerHand,
                    dealer: true))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                try {
                  Provider.of<BlackJack>(context, listen: false).getNewCard();
                  Provider.of<BlackJack>(context, listen: false)
                      .blackJackOrBustCheck('Player');
                } catch (e) {
                  //gör en popup som säger att du inte kan dra kort FIXA
                }
              },
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
            Column(
              children: [
                const Icon(Icons.money, size: 50),
                Consumer(
                    builder: (context, state, child) => Text(
                        '${Provider.of<BlackJack>(context, listen: false).getPlayerBet}'))
              ],
            ),
            IconButton(
                onPressed: () {
                  Provider.of<BlackJack>(context, listen: false).stop('Player');
                  Provider.of<BlackJack>(context, listen: false).dealersTurn();
                  Provider.of<BlackJack>(context, listen: false)
                      .winOrLose('Player');
                },
                icon: const Icon(Icons.stop, size: 40))
          ],
        ),
        SizedBox(
            width: 200,
            child: Consumer<BlackJack>(
                builder: (context, state, child) => getHand(
                    Provider.of<BlackJack>(context, listen: false)
                        .getPlayerHand,
                    dealer: false))),
      ],
    );
  }

  Widget getHand(List<PlayingCard> hand, {required bool dealer}) {
    //genererar vyn för spelaren och dealerns kort
    //ska dealern även visa kort om du blir tjock eller får blackjack utan att den tar en tur

    bool showDealerCard =
        Provider.of<BlackJack>(context, listen: false).getDealerCardShown;

    List<Widget> viewHand = <Widget>[];
    for (int i = 0; i < hand.length; i++) {
      viewHand.add(SizedBox(
          height: 153,
          width: 116,
          child: PlayingCardView(
              card: hand[i],
              elevation: 3.0,
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

  Widget winOrLosePopUp(String winOrLose) {
    //popup om du vinner eller förlorar där du kan starta en ny runa eller gå till startsidan?
    switch (winOrLose) {
      case 'NoWinnerYet':
        {
          return const SizedBox.shrink();
        }
      case 'Win':
        {
          return AlertDialog(
            title: const Text('Congratulations'),
            content: const Text('You Won!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Provider.of<BlackJack>(context, listen: false)
                        .winnings('Player');
                    Provider.of<BlackJack>(context, listen: false)
                        .setUpNewGame();
                    //lägg till förändringar till saldo samt bet här
                  },
                  child: const Text('Ok'))
            ],
          );
        }
      case 'Lose':
        {
          return AlertDialog(
            title: const Text('Bad luck!'),
            content: const Text('You Lost the round'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Provider.of<BlackJack>(context, listen: false)
                        .setUpNewGame();
                    //lägg till förändringar till saldo samt bet här
                  },
                  child: const Text('Ok'))
            ],
          );
        }
      case 'Draw':
        {
          return AlertDialog(
            title: const Text('Draw!'),
            content: const Text('You got the same score as the dealer'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Provider.of<BlackJack>(context, listen: false)
                        .drawBet('Player');
                    Provider.of<BlackJack>(context, listen: false)
                        .setUpNewGame();
                    //lägg till förändringar till saldo samt bet här
                  },
                  child: const Text('Ok'))
            ],
          );
        }
      default:
        {
          return const SizedBox.shrink();
        }
    }
  }
}
