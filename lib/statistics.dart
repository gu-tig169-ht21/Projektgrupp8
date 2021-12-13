import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statisctis'),
        centerTitle: true,
      ),
      body: Stack(children: [
        _gamesWon(),
        _playTime(),
        _gamesLost(),
        _mostCommonCard(),
        _statisticsMostCommonCard()
      ]),
    );
  }
}

// vyn/positionering till antalet vunna matcher, saknar det verkliga värdet
Widget _gamesWon() {
  return Stack(children: [
    Positioned(
      top: 30,
      left: 30,
      height: 100,
      width: 100,
      child: Container(
        width: 70,
        height: 70,
        child: const Text(
          'Games won',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  ]);
}

// vyn/positionering till antalet spelade matcher, saknar det verkliga värdet

Widget _playTime() {
  return Stack(children: [
    Positioned(
      top: 30,
      left: 70,
      height: 100,
      width: 100,
      child: Container(
        width: 70,
        height: 70,
        child: const Text(
          'Hours played',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  ]);
}

// vyn/positionering till antalet förlorade matcher, saknar det verkliga värdet

Widget _gamesLost() {
  return Stack(children: const [
    Positioned(
      top: 30,
      left: 100,
      height: 100,
      width: 100,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Text(
          'Games Lost',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  ]);
}

// vyn/positionering till bilden av kortet för mest dragna kortet, saknar det verkliga värdet

Widget _mostCommonCard() {
  return Stack(children: const [
    Positioned(
      top: 60,
      left: 100,
      height: 100,
      width: 100,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Text(
          'This is your most common card',
          style: TextStyle(fontSize: 20),
          //implementera in värdet
        ),
      ),
    ),
  ]);
}

// vyn/positionering till barcharten, saknar det verkliga värdet

Widget _statisticsMostCommonCard() {
  return Stack(children: const [
    Positioned(
      top: 100,
      left: 100,
      height: 100,
      width: 100,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Text(
          'Statistics of your most drawn cards',
          style: TextStyle(fontSize: 20),
          //implementera in barchart-widget
        ),
      ),
    ),
  ]);
}
