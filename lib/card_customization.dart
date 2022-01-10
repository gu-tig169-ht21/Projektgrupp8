import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playing_cards/playing_cards.dart';
import 'card_themes.dart';
import 'blackjack.dart';

//TODO: finjustera balances storlek i theme

class CustomizationPage extends StatelessWidget {
  CustomizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: [
          _balance(context),
        ],
      ),
      body: Stack(
        children: [
          _cardView(context),
          _purchaseDeckButton(context),
          _changeDeckButton(context),
        ],
      ),
    );
  }

//widget för titlen
  Widget _title() {
    return const Text('Card Customization');
  }

//widget för den aktuella balansen/saldot du har i appen
  Widget _balance(context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
                '\$ ${Provider.of<PlayingCardsProvider>(context, listen: false).getBalance(context: context)}'))
      ],
    );
  }

//pagecontroller för att kunna ha koll på de olika sidorna
  PageController pageController = PageController(viewportFraction: 0.7);
  var value = 0;

//widget lista med de olika korten
  Widget _cardView(BuildContext context) {
    List<Widget> cardList = <Widget>[
      _card1(context),
      _card2(context),
      _card3(context)
    ];
    return Align(
      alignment: const Alignment(0, -0.4),
      child: SizedBox(
        height: 350,
        width: 350,
        child: PageView(
          onPageChanged: (index) => {
            Provider.of<PlayingCardsProvider>(context, listen: false)
                .setChosenPageViewCard = index
          },
          controller: pageController,
          children: cardList,
        ),
      ),
    );
  }

//widget för köp knapp
  Widget _purchaseDeckButton(context) {
    String _deck = 'Standard';
    int _price = 0;
    if (Provider.of<PlayingCardsProvider>(context, listen: false)
            .getChosenPageViewCard ==
        1) {
      _deck = 'StarWars';
      _price = Provider.of<PlayingCardsProvider>(context, listen: false)
          .getStarWarsDeckPrice;
    } else if (Provider.of<PlayingCardsProvider>(context, listen: false)
            .getChosenPageViewCard ==
        2) {
      _deck = 'Golden';
      _price = Provider.of<PlayingCardsProvider>(context, listen: false)
          .getGoldenDeckPrice;
    }

    return Align(
      alignment: const Alignment(0, 0.6),
      child: FractionallySizedBox(
        widthFactor: 0.45,
        heightFactor: 0.09,
        child: Consumer<PlayingCardsProvider>(
          builder: (context, state, child) {
            return ElevatedButton(
              //kollar om vi har råd och köpa deck
              //kollar om vi äger decket
              //om köp gjordes, saldot justeras
              //decket ändras till att vara upplåst
              onPressed: () {
                if (Provider.of<PlayingCardsProvider>(context, listen: false)
                        .affordDeck(_deck, context) &&
                    !Provider.of<PlayingCardsProvider>(context, listen: false)
                        .getDeckUnlocked(
                            starWarsOrGolden: _deck, context: context)) {
                  Provider.of<BlackJack>(context, listen: false)
                      .subtractFromBalance(i: _price, context: context);
                  Provider.of<PlayingCardsProvider>(context, listen: false)
                      .setDeckUnlocked(
                          starWarsOrGolden: _deck, context: context);
                } else {
                  null;
                }
              },
              child: const Text('Purchase'),
              style: ButtonStyle(
                backgroundColor:
                    //ändrar färg beroende på
                    // om vi har råd
                    // kollar om vi äger decket
                    (Provider.of<PlayingCardsProvider>(context, listen: false)
                                .affordDeck(_deck, context) &&
                            !Provider.of<PlayingCardsProvider>(context,
                                    listen: false)
                                .getDeckUnlocked(
                                    starWarsOrGolden: _deck, context: context))
                        ? null
                        : MaterialStateProperty.all(Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

// widget som returnerar en knapp som du trycker på
//för att ändra din valda kortlek till en ny kortlek
  Widget _changeDeckButton(context) {
    String _deck = 'Standard';

    //hämtar vilket kort du står på i listan så vi kan
    //skicka vidare det sen

    if (Provider.of<PlayingCardsProvider>(context, listen: false)
            .getChosenPageViewCard ==
        0) {
      _deck = 'Standard';
    } else if (Provider.of<PlayingCardsProvider>(context, listen: false)
            .getChosenPageViewCard ==
        1) {
      _deck = 'StarWars';
    } else {
      _deck = 'Golden';
    }
    return Align(
      alignment: const Alignment(0, 0.85),
      child: FractionallySizedBox(
        widthFactor: 0.65,
        heightFactor: 0.09,
        child: ElevatedButton(
          child: const Text('Choose this deck'),
          onPressed: () {
            //väljer de kort som skall komma till spelplanen
            //välj det deck som är upplåst (går inte att välja oköpt deck)
            if (Provider.of<PlayingCardsProvider>(context, listen: false)
                    .getChosenPageViewCard ==
                0) {
              Provider.of<PlayingCardsProvider>(context, listen: false)
                  .changePlayingCardsThemes(
                      style: 'Standard', context: context);
            } else if (Provider.of<PlayingCardsProvider>(context, listen: false)
                        .getChosenPageViewCard ==
                    1 &&
                Provider.of<PlayingCardsProvider>(context, listen: false)
                    .getStarWarsDeckUnlocked) {
              Provider.of<PlayingCardsProvider>(context, listen: false)
                  .changePlayingCardsThemes(
                      style: 'StarWars', context: context);
            } else if (Provider.of<PlayingCardsProvider>(context, listen: false)
                        .getChosenPageViewCard ==
                    2 &&
                Provider.of<PlayingCardsProvider>(context, listen: false)
                    .getGoldenDeckUnlocked) {
              Provider.of<PlayingCardsProvider>(context, listen: false)
                  .changePlayingCardsThemes(style: 'Golden', context: context);
            }
          },
          style: ButtonStyle(
            //om vi äger decket så ändrar de färg på knappen
            backgroundColor: (Provider.of<PlayingCardsProvider>(context,
                        listen: false)
                    .getDeckUnlocked(starWarsOrGolden: _deck, context: context))
                ? null
                : MaterialStateProperty.all(Colors.grey),
          ),
        ),
      ),
    );
  }
}

Widget _card1(BuildContext context) {
  return Stack(
    children: [
      Column(
        children: [
          FlatCardFan(
            children: [
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.hearts, CardValue.king),
                  elevation: 10,
                  showBack: true,
                ),
              ),
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.hearts, CardValue.king),
                  elevation: 10,
                ),
              ),
            ],
          ),
          const Text(
            'Standard Deck',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const Text(
            //TODO: ändra denna texten sen
            'Standard',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Align(
        alignment: Alignment.topRight,
        child: (Provider.of<PlayingCardsProvider>(context, listen: true)
                    .getCardStyleString ==
                'Standard')
            ? const Icon(
                Icons.check_sharp,
                size: 45,
                color: Colors.green,
              )
            : const SizedBox.shrink(),
      ),
    ],
  );
}

Widget _card2(BuildContext context) {
  return Stack(
    children: [
      Column(
        children: [
          FlatCardFan(
            children: [
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.clubs, CardValue.king),
                  showBack: true,
                  elevation: 10,
                ),
              ),
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.clubs, CardValue.king),
                  elevation: 10,
                  style: PlayingCardsThemes.starWarsStyle,
                ),
              ),
            ],
          ),
          const Text(
            'Star Wars Edition',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          Text(
            '\$ ${Provider.of<PlayingCardsProvider>(context, listen: false).getStarWarsDeckPrice}',
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Align(
        alignment: Alignment.topRight,
        child: (Provider.of<PlayingCardsProvider>(context, listen: true)
                    .getCardStyleString ==
                'StarWars')
            ? const Icon(
                Icons.check_sharp,
                size: 45,
                color: Colors.green,
              )
            : const SizedBox.shrink(),
      ),
    ],
  );
}

Widget _card3(BuildContext context) {
  return Stack(
    children: [
      Column(
        children: [
          FlatCardFan(
            children: [
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.spades, CardValue.king),
                  showBack: true,
                  elevation: 10,
                  style: PlayingCardsThemes.goldenStyle,
                ),
              ),
              SizedBox(
                width: 200,
                height: 278,
                child: PlayingCardView(
                  card: PlayingCard(Suit.spades, CardValue.king),
                  elevation: 10,
                  style: PlayingCardsThemes.goldenStyle,
                ),
              ),
            ],
          ),
          const Text(
            'Golden Deck',
            style: TextStyle(fontSize: 25),
          ),
          Text(
            '\$ ${Provider.of<PlayingCardsProvider>(context, listen: false).getGoldenDeckPrice}',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
      Align(
        alignment: Alignment.topRight,
        child: (Provider.of<PlayingCardsProvider>(context, listen: true)
                    .getCardStyleString ==
                'Golden')
            ? const Icon(
                Icons.check_sharp,
                size: 45,
                color: Colors.green,
              )
            : const SizedBox.shrink(),
      ),
    ],
  );
}
