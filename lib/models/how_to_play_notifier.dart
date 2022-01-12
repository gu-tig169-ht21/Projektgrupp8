import 'package:flutter/cupertino.dart';

class HowToPlayNotifier extends ChangeNotifier {
  String _chosenChapter = 'How to play';

  String get getChosenChapter {
    return _chosenChapter;
  }

  void chooseChapter(String choice) {
    _chosenChapter = choice;
    notifyListeners();
  }
}
