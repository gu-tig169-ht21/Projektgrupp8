import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'blackjack.dart';
import 'deck_of_cards.dart';
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
    BlackJack().resetDeck();
    BlackJack().clearHands();
    BlackJack().startingHands();

    return Column(
      //när spelaren tryckt på knapp så får dealrn sin tur FIXA
      children: [
        Consumer<BlackJack>(
            builder: (context, state, child) =>
                getHand(BlackJack().dealerHand)),
        Row(
          children: [
            IconButton(
              onPressed: () {
                try {
                  Provider.of<BlackJack>(context, listen: false).getNewCard();
                } catch (e) {
                  //gör en popup som säger att du inte kan dra kort FIXA
                }
              },
              icon: const Icon(Icons.plus_one),
            ),
            Column(
              children: [
                const Icon(Icons.money),
                Consumer(
                    builder: (context, state, child) =>
                        Text('${BlackJack().playerBet}'))
              ],
            ),
            IconButton(
                onPressed: () {
                  Provider.of<BlackJack>(context, listen: false).stop('Player');
                },
                icon: const Icon(Icons.stop))
          ],
        ),
        Consumer<BlackJack>(
            builder: (context, state, child) =>
                getHand(BlackJack().playerHand)),
      ],
    );
  }

  Widget getHand(List<PlayingCard> hand) {
    List<Widget> viewHand = <Widget>[];
    for (PlayingCard card in hand) {
      viewHand.add(PlayingCardView(card: card));
    }
    return Row(
      children: viewHand,
    );
  }
}
