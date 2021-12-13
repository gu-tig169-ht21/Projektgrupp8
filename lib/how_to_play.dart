import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rules.dart';

String dropDownValue = 'How to play';

//class med changenotifier
class HowToPlay extends ChangeNotifier {
  String chosenChapter = 'How to play';

  void chooseChapter(String choice) {
    dropDownValue = choice;
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
            iconEnabledColor: Colors.white,
            style: const TextStyle(fontSize: 20),
            value: dropDownValue,
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
            builder: (context, state, child) => getText(dropDownValue)));
  }

  Widget getText(String chosenText) {
    return Column(
      children: [
        Center(
          child: Text(
            RuleText.returnRules(chosenText),
          ),
        ),
      ],
    );
  }
}
