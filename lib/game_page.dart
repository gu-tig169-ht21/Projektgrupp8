import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blackjack.dart';
import 'package:playing_cards/playing_cards.dart';

int saldo = 300;

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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
        SizedBox(
            width: 200,
            child: Consumer<BlackJack>(
                builder: (context, state, child) => getHand(
                    Provider.of<BlackJack>(context, listen: false)
                        .getDealerHand))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                try {
                  Provider.of<BlackJack>(context, listen: false).getNewCard();
                  Provider.of<BlackJack>(context, listen: false)
                      .winOrLose('Player');
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
                        .getPlayerHand))),
      ],
    );
  }

  Widget getHand(List<PlayingCard> hand) {
    List<Widget> viewHand = <Widget>[];
    for (PlayingCard card in hand) {
      viewHand.add(SizedBox(
          height: 133,
          width: 96,
          child: PlayingCardView(
            card: card,
            elevation: 3.0,
          )));
    }
    return FlatCardFan(children: viewHand);
  }

  Widget? winOrLosePopUp(String winOrLose) {
    switch (winOrLose) {
      case 'NoWinnerYet':
        {
          return const SizedBox.shrink();
        }
      case 'Winner':
        {
          return AlertDialog(
            title: const Text('Congratulations'),
            content: const Text('You Won!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Provider.of<BlackJack>(context, listen: false).resetDeck();
                    Provider.of<BlackJack>(context, listen: false).clearHands();
                    Provider.of<BlackJack>(context, listen: false)
                        .startingHands();
                    //lägg till förändringar till saldo samt bet här
                  },
                  child: const Text('Ok'))
            ],
          );
        }
    }
  }
}
