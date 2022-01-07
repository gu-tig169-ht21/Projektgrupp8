import 'package:flutter/cupertino.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:provider/provider.dart';

class StatisticsProvider extends ChangeNotifier{
  int gamesPlayed = 0;
  int gamesWon = 0;
  int gamesLost = 0;
  dynamic drawnCards;


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


}