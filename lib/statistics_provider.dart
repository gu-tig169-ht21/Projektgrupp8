import 'package:flutter/cupertino.dart';
import 'package:my_first_app/deck_of_cards.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';

class DrawnCard{
  String name;
  int timesDrawn;

  DrawnCard(this.name, this.timesDrawn);
}

class StatisticsProvider extends ChangeNotifier{
  int gamesPlayed = 0;
  int gamesWon = 0;
  int gamesLost = 0;
  Map<String, dynamic> drawnCards = <String, dynamic>{};


  get getGamesPlayed{
    return gamesPlayed;
  }
  get getGamesWon{
    return gamesWon;
  }
  get getGamesLost{
    return gamesLost;
  }

  Future<void> setUpStatistics({required BuildContext context}) async{
    String userId = Provider.of<FirebaseAuthImplementation>(context, listen: false).getUserId()!;


    gamesPlayed = await Provider.of<FirestoreImplementation>(context, listen: false).getGamesPlayed(userId: userId);
    gamesWon = await Provider.of<FirestoreImplementation>(context, listen: false).getGamesWon(userId: userId);
    gamesLost = await Provider.of<FirestoreImplementation>(context, listen: false).getGamesLost(userId: userId);
    drawnCards = await Provider.of<FirestoreImplementation>(context, listen: false).getDrawnCards(userId: userId);

    notifyListeners();
  }

  List<DrawnCard> drawnCardsToList(){
    List<DrawnCard> drawnCardsList = <DrawnCard>[];

    drawnCards.forEach((key, value) {
      drawnCardsList.add(DrawnCard(key, value));
    });

    return drawnCardsList;
  }

  PlayingCard mostDrawnCard(){
    List<DrawnCard> drawnCardsList = <DrawnCard>[];

    drawnCards.forEach((key, value) {
      drawnCardsList.add(DrawnCard(key, value));
    });

    drawnCardsList.sort((a, b) => b.timesDrawn.compareTo(a.timesDrawn));

    return DeckOfCards().stringToCard(cardString: drawnCardsList[0].name);
  }


}