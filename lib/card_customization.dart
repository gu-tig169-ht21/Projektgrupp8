//fil där vi skall göra en sida för kort redigering

import 'package:flutter/material.dart';
import 'how_to_play.dart';

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
          _leftButton(),
          _rightButton(),
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

//widget för kortet
  Widget _card() {
    //här skall vi göra kort funktionen
    return const Text('Här skall vi göra ett kort');
  }

//widget för den vänstra byt-kort-knappen
  Widget _leftButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 300,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_left),
            iconSize: 40,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

//widget för den högra byt-kort-knappen
  Widget _rightButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 300,
          right: 20,
          child: IconButton(
            iconSize: 40,
            icon: const Icon(Icons.arrow_right),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

//widget som visar en text med namnet på kortleken
  Widget _chosenCardTitle() {
    return Stack(
      children: const [
        Positioned(
          bottom: 150,
          right: 70,
          child: Text(
            'Här skall stå namn på vald kortlek',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

// widget som returnerar en knapp som du trycker på
//för att ändra din valda kortlek till en ny kortlek
  Widget _changeDeckButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 80,
          left: 70,
          right: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 20)),
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
        ),
      ],
    );
  }
}
