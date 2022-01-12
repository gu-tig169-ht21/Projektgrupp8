import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rules.dart';
import '../models/theme_mode_switch.dart';
import '../models/how_to_play_notifier.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //appbar med en dropdownbutton
        title: DropdownButton(
          iconSize: 40,
          iconEnabledColor: Colors.black,
          style: TextStyle(
              //ändrar färg beroende på om thememode är dark eller standard
              color: Provider.of<ChangeTheme>(context, listen: false)
                      .getThemeModeSwitch
                  ? Colors.white
                  : Colors.black,
              fontSize: 20),
          value: Provider.of<HowToPlayNotifier>(context, listen: true)
              .getChosenChapter,
          onChanged: (String? chosenValue) {
            //kallar på funktionen med hjälp av en provider
            Provider.of<HowToPlayNotifier>(context, listen: false)
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
      body: Consumer<HowToPlayNotifier>(
        //consumar värdet på getchosenchapter som bestämmer vilken vy som ska
        //visas
        builder: (context, state, child) => _getText(
            Provider.of<HowToPlayNotifier>(context, listen: false)
                .getChosenChapter),
      ),
    );
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
