import 'package:flutter/cupertino.dart';
import 'package:my_first_app/game_engine/deck_of_cards.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import '../game_engine/error_handling.dart';

class DrawnCard {
  String name;
  int timesDrawn;

  DrawnCard(this.name, this.timesDrawn);
}

class StatisticsHandler extends ChangeNotifier {
  int _gamesPlayed = 0;
  int _gamesWon = 0;
  int _gamesLost = 0;
  Map<String, dynamic> _drawnCards = <String, dynamic>{};

  get getGamesPlayed {
    return _gamesPlayed;
  }

  get getGamesWon {
    return _gamesWon;
  }

  get getGamesLost {
    return _gamesLost;
  }

  Future<void> setUpStatistics({required BuildContext context}) async {
    String userId = '0';
    try {
      userId = Provider.of<FirebaseAuthImplementation>(context, listen: false)
          .getUserId()!;
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    try {
      _gamesPlayed =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getGamesPlayed(userId: userId, context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    try {
      _gamesWon =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getGamesWon(userId: userId, context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    try {
      _gamesLost =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getGamesLost(userId: userId, context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
    try {
      _drawnCards =
          await Provider.of<FirestoreImplementation>(context, listen: false)
              .getDrawnCards(userId: userId, context: context);
    } on Exception catch (e) {
      ErrorHandling().errorHandling(e, context);
    }

    notifyListeners();
  }

  List<DrawnCard> drawnCardsToList() {
    List<DrawnCard> drawnCardsList = <DrawnCard>[];

    _drawnCards.forEach((key, value) {
      drawnCardsList.add(DrawnCard(key, value));
    });

    return drawnCardsList;
  }

  PlayingCard mostDrawnCard() {
    List<DrawnCard> drawnCardsList = <DrawnCard>[];

    _drawnCards.forEach((key, value) {
      drawnCardsList.add(DrawnCard(key, value));
    });

    drawnCardsList.sort((a, b) => b.timesDrawn.compareTo(a.timesDrawn));

    return DeckOfCards().stringToCard(cardString: drawnCardsList[0].name);
  }
}
