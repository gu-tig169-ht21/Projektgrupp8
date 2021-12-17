//fil där vi skall göra en sida för kort redigering

import 'package:flutter/material.dart';
import 'how_to_play.dart';
import 'package:playing_cards/playing_cards.dart';
import 'card_themes.dart';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({Key? key}) : super(key: key);

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: [
          _balance(),
        ],
      ),
      body: Stack(
        children: [
          _card(),
          _changeDeckButton(),
        ],
      ),
    );
  }

//widget för titlen
  Widget _title() {
    return Row(
      children: const [
        Text(
          'Card Customization',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

//widget för den aktuella balansen/saldot du har i appen
  Widget _balance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '100kr',
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }

//widget för kortet
  Widget _card() {
    //här skall vi göra kort funktionen
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 350,
        width: 310,

        //Funktion som gör att man kan scrolla bland korten
        child: PageView(
          controller: PageController(viewportFraction: 0.7),
          // onPageChanged: (),//Hur mycket av nästa kort man ser
          children: [
            _card1(),
            _card2(),
            _card3(),
          ],
        ),
      ),
    );
  }

//skriva in priset på de olika decken
//plus göra en text med ditt saldo

// widget som returnerar en knapp som du trycker på
//för att ändra din valda kortlek till en ny kortlek
  Widget _changeDeckButton() {
    return Positioned(
      bottom: 40,
      left: 70,
      right: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: const Size(70, 20)),
        child: const Text('Choose this deck'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpPage(),
            ),
          );
        },
      ),
    );
  }
}

Widget _card1() {
  return SizedBox(
    width: 1000,
    child: Column(
      children: [
        FlatCardFan(
          children: [
            PlayingCardView(
              card: PlayingCard(Suit.hearts, CardValue.king),
              // style: StarWarsDeck.starWarsStyle,
              // showBack: true,
              elevation: 10.0,
            ),
            PlayingCardView(
              card: PlayingCard(Suit.hearts, CardValue.ace),
              elevation: 3.0,
            ),
          ],
        ),
        const Text(
          'Standard Deck',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
        const Text(
          'Upplåst',
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

Widget _card2() {
  return Column(
    children: [
      FlatCardFan(
        children: [
          PlayingCardView(
            card: PlayingCard(Suit.hearts, CardValue.king),
            // showBack: true,
            elevation: 10.0,
          ),
          PlayingCardView(
            card: PlayingCard(Suit.hearts, CardValue.ace),
            elevation: 3.0,
            // style: StarWarsDeck.starWarsStyle,
          ),
        ],
      ),
      const Text(
        'Star Wars Edition',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      const Text(
        '10kr',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      )
    ],
  );
}

Widget _card3() {
  return Column(
    children: [
      FlatCardFan(
        children: [
          PlayingCardView(
            card: PlayingCard(Suit.spades, CardValue.queen),
            showBack: true,
            elevation: 10.0,
            style: StarWarsDeck.starWarsStyle,
          ),
          PlayingCardView(
            card: PlayingCard(Suit.spades, CardValue.queen),
            elevation: 3.0,
            style: StarWarsDeck.starWarsStyle,
          ),
        ],
      ),
      const Text(
        'Golden Deck',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      const Text(
        '1 000 000kr',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      )
    ],
  );
}
