import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
//lista där värdena som ska visas
  late List<charts.Series> seriesList;

  static List<charts.Series<CommonCardChart, String>> _createRandomData() {
    final random = Random();

//värdena som presenteras i barchart

    final statisticsCardData = [
      CommonCardChart('Ace of spades', '${random.nextInt(100)}'),
      CommonCardChart('King of hearts', '${random.nextInt(100)}'),
      CommonCardChart('Queen of diamonds', '${random.nextInt(100)}'),
      CommonCardChart('Jack of clubs', '${random.nextInt(100)}'),
    ];
    return [
      charts.Series<CommonCardChart, String>(
        id: 'times',
        domainFn: (CommonCardChart times, _) => times.card,
        measureFn: (CommonCardChart times, _) => int.parse(times.times),
        data: statisticsCardData,
      )
    ];
  }

//widget för barchart

  barChart() {
    return Align(
        alignment: const Alignment(0, 1.0),
        child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.4,
            child: charts.BarChart(
              _createRandomData(),
              animate: true,
              vertical: true,
            )));
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: Stack(children: [
        _gamesWon(),
        _gamesWonValue(),
        _playTime(),
        _playTimeValue(),
        _gamesLost(),
        _gamesLostValue(),
        _mostCommonCard(),
        _mostCommonCardValue(),
        _statisticsMostCommonCard(),
        barChart(),
      ]),
    );
  }
}

// vyn/positionering till antalet vunna matcher, saknar det verkliga värdet
Widget _gamesWon() {
  return const Align(
    alignment: Alignment(-0.9, -0.9),
    child: FractionallySizedBox(
      widthFactor: 0.20,
      heightFactor: 0.1,
      child: Text(
        'Games won',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

Widget _gamesWonValue() {
  return const Align(
    alignment: Alignment(-0.75, -0.8),
    child: FractionallySizedBox(
      widthFactor: 0.1,
      heightFactor: 0.1,
      child: Text(
        '8',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

// vyn/positionering till antalet spelade matcher, saknar det verkliga värdet

Widget _playTime() {
  return const Align(
    alignment: Alignment(0.0, -0.9),
    child: FractionallySizedBox(
      widthFactor: 0.20,
      heightFactor: 0.1,
      child: Text(
        'Time played',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

Widget _playTimeValue() {
  return const Align(
    alignment: Alignment(0.05, -0.8),
    child: FractionallySizedBox(
      widthFactor: 0.1,
      heightFactor: 0.1,
      child: Text(
        '8',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

// vyn/positionering till antalet förlorade matcher, saknar det verkliga värdet

Widget _gamesLost() {
  return const Align(
    alignment: Alignment(0.9, -0.9),
    child: FractionallySizedBox(
      widthFactor: 0.20,
      heightFactor: 0.1,
      child: Text(
        'Games lost',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

Widget _gamesLostValue() {
  return const Align(
    alignment: Alignment(0.9, -0.8),
    child: FractionallySizedBox(
      widthFactor: 0.1,
      heightFactor: 0.1,
      child: Text(
        '8',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

// vyn/positionering till bilden av kortet för mest dragna kortet, saknar det verkliga värdet

Widget _mostCommonCard() {
  return const Align(
    alignment: Alignment(0.0, -0.6),
    child: FractionallySizedBox(
      widthFactor: 0.35,
      heightFactor: 0.1,
      child: Text(
        'Your most common card',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

Widget _mostCommonCardValue() {
  return const Align(
    alignment: Alignment(0.0, -0.4),
    child: FractionallySizedBox(
      widthFactor: 0.1,
      heightFactor: 0.1,
      child: Text(
        '8',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

// vyn/positionering till barcharten, saknar det verkliga värdet

Widget _statisticsMostCommonCard() {
  return const Align(
    alignment: Alignment(0.0, 0.1),
    child: FractionallySizedBox(
      widthFactor: 0.35,
      heightFactor: 0.1,
      child: Text(
        'Chart of yor most common cards',
        style: TextStyle(fontSize: 15),
      ),
    ),
  );
}

//klass för de olika attributen barchart

class CommonCardChart {
  final String card;
  final String times;
  CommonCardChart(this.card, this.times);
}
