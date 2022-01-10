import 'package:flutter/material.dart';
import 'package:my_first_app/blackjack.dart';
import 'package:my_first_app/settings_page.dart';
import 'package:provider/provider.dart';
import 'rules.dart';

//fixa så att texten ändras i rutan utan att använda setstate eftersom vi använder provider.

//class med changenotifier
class HowToPlay extends ChangeNotifier {
  String chosenChapter = 'How to play';

  String get getChosenChapter {
    return chosenChapter;
  }

  void chooseChapter(String choice) {
    chosenChapter = choice;
    notifyListeners();
  }
}

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
                Provider.of<HowToPlay>(context, listen: true).getChosenChapter,
            onChanged: (String? chosenValue) {
              //kallar på funktionen med hjälp av en provider
              Provider.of<HowToPlay>(context, listen: false)
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
        body: Consumer<HowToPlay>(
            builder: (context, state, child) => getText(
                Provider.of<HowToPlay>(context, listen: false)
                    .getChosenChapter)));
  }

  Widget getText(String chosenText) {
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
