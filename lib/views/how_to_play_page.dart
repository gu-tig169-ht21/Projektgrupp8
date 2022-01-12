import 'package:flutter/material.dart';
import 'package:my_first_app/game_engine/blackjack.dart';
import 'package:my_first_app/views/settings_page.dart';
import 'package:provider/provider.dart';
import '../models/rules.dart';

//fixa så att texten ändras i rutan utan att använda setstate eftersom vi använder provider.

//class med changenotifier
class HowToPlayPage extends ChangeNotifier {
  String _chosenChapter = 'How to play';

  String get getChosenChapter {
    return _chosenChapter;
  }

  void chooseChapter(String choice) {
    _chosenChapter = choice;
    notifyListeners();
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //appbar med en dropdownbutton
          title: DropdownButton(
            iconSize: 40,
            iconEnabledColor: Colors.black,
            style: TextStyle(
                color: Provider.of<ChangeTheme>(context, listen: false)
                        .getThemeModeSwitch
                    ? Colors.white
                    : Colors.black,
                fontSize: 20),
            value:
                Provider.of<HowToPlayPage>(context, listen: true).getChosenChapter,
            onChanged: (String? chosenValue) {
              //kallar på funktionen med hjälp av en provider
              Provider.of<HowToPlayPage>(context, listen: false)
                  .chooseChapter(chosenValue!);
            },
            //lista med de alternativ användaren får
            items: <String>[
              'How to play',
              'Card values',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),
        body: Consumer<HowToPlayPage>(
            builder: (context, state, child) => _getText(
                Provider.of<HowToPlayPage>(context, listen: false)
                    .getChosenChapter)));
  }

  Widget _getText(String chosenText) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 40, bottom: 20),
          child: RuleText().returnRules(chosenText),
        ),
      ),
    );
  }
}
