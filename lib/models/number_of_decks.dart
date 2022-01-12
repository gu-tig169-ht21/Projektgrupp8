import 'package:flutter/cupertino.dart';

class ChangeNumberOfDecks with ChangeNotifier {
  final List<String> _numberDecks = ['1', '2', '3', '4', '5'];
  late int _selectedNumberOfDecks = 1;

  List<String> get getNumberDecks => _numberDecks;
  int get getSelectedNumberOfDecks => _selectedNumberOfDecks;

  void setSelectedDecks(String x) {
    _selectedNumberOfDecks = int.parse(x);
    notifyListeners();
  }
}
