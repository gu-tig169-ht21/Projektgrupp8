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
      body: Stack(
        children: [
          _title(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Card Customization',
          style: TextStyle(fontSize: 50),
        ),
      ],
    );
  }

//widget för kortet
  Widget _card() {
    return const Text('här skall vi göra ett kort');
  }

//widget för den vänstra byt-kort-knappen
  Widget _leftButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 240,
          left: 100,
          right: 100,
          child: IconButton(
            icon: const Icon(Icons.arrow_left),
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
          bottom: 240,
          left: 100,
          right: 100,
          child: IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

//widget som visar en text med namnet på kortleken
  Widget _chosenCardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'här skall stå namn på vald kortlek:)',
          style: TextStyle(fontSize: 50),
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
          bottom: 240,
          left: 100,
          right: 100,
          child: ElevatedButton(
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
