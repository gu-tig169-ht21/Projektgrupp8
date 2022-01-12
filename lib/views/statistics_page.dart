import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_first_app/models/statistics_handler.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    setUpStats();
    super.initState();
  }

  void setUpStats() async {
    await Provider.of<StatisticsHandler>(context, listen: false)
        .setUpStatistics(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: Stack(children: [
        statisticsCards(context: context),
        _mostDrawnCardTitle(),
        _mostDrawnCard(context),
        _chartTitle(),
        barChart(context),
      ]),
    );
  }
}

List<charts.Series<DrawnCard, String>> _getChartData(BuildContext context) {
//värden som presenteras i barchart

//hämtar kort och hur de blivit många gånger alla korten blivit dragna
  List<DrawnCard> cards =
      Provider.of<StatisticsHandler>(context, listen: false).drawnCardsToList();

//sorterar korten i ordning utefter hur många gånger man dragit dem
  cards.sort((a, b) => b.timesDrawn.compareTo(a.timesDrawn));

  final statisticsCardData = [
    cards[0],
    cards[1],
    cards[2],
    cards[3],
    cards[4],
  ];
  return [
    charts.Series<DrawnCard, String>(
      id: 'times',
      domainFn: (DrawnCard card, _) => card.name,
      measureFn: (DrawnCard card, _) => card.timesDrawn,
      data: statisticsCardData,
      labelAccessorFn: (DrawnCard card, _) => '${card.timesDrawn}',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
    ),
  ];
}

//widget för barchart

barChart(BuildContext context) {
  return Align(
    alignment: const Alignment(0, 1.0),
    child: FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: 0.4,
      child: charts.BarChart(
        _getChartData(context),
        animate: true,
        vertical: true,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
      ),
    ),
  );
}

Widget statisticsCards({required BuildContext context}) {
  return Row(children: <Widget>[
    Expanded(
      child: SizedBox(
        width: 200,
        height: 70,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Games won \n ${Provider.of<StatisticsHandler>(context, listen: true).getGamesWon}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
    Expanded(
      child: SizedBox(
        width: 200,
        height: 70,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Games played \n ${Provider.of<StatisticsHandler>(context, listen: true).getGamesPlayed}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
    Expanded(
      child: SizedBox(
        width: 200,
        height: 70,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Games lost \n ${Provider.of<StatisticsHandler>(context, listen: true).getGamesLost}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  ]);
}

// vyn/positionering till bilden av kortet för mest dragna kortet, saknar det verkliga värdet

Widget _mostDrawnCardTitle() {
  return const Align(
    alignment: Alignment(0.0, -0.7),
    child: FractionallySizedBox(
      widthFactor: 0.35,
      heightFactor: 0.1,
      child: Text(
        'Your most common card',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

// widget för vilket kort som är vanligast att dra/bild
Widget _mostDrawnCard(BuildContext context) {
  return Align(
    alignment: const Alignment(0.0, -0.45),
    child: SizedBox(
      width: 120,
      child: PlayingCardView(
        card: Provider.of<StatisticsHandler>(context, listen: false)
            .mostDrawnCard(),
        elevation: 10,
      ),
    ),
  );
}

Widget _chartTitle() {
  return const Align(
    alignment: Alignment(0.0, 0.2),
    child: FractionallySizedBox(
      widthFactor: 0.35,
      heightFactor: 0.1,
      child: Text(
        'Chart of your most common cards',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
