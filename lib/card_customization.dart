//fil där vi skall göra en sida för kort redigering

import 'package:flutter/material.dart';
import 'how_to_play.dart';
import 'package:playing_cards/playing_cards.dart';

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
      ),
      body: Stack(
        children: [
          _card(),
          //_leftButton(),
          //_rightButton(),
          _chosenCardTitle(),
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

  int _index = 0;

//widget för kortet
  Widget _card() {
    //här skall vi göra kort funktionen
    return Align(
        alignment: Alignment.center,
        child: SizedBox(
            height: 350,
            width: 310,

            //Funktion som gör att man kan scrolla bland korten
            child: PageView.builder(
                itemCount: 3,
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: PlayingCardView(
                          card: PlayingCard(Suit.clubs, CardValue.nine)));
                })));
  }

//Gör en funktion som visar tre olika kort
//Gör en Lista med tre kort

//widget som visar en text med namnet på kortleken
  Widget _chosenCardTitle() {
    return const Positioned(
      bottom: 100,
      left: 70,
      right: 70,
      child: Text(
        'Normal Deck',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

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
