import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'rules.dart';

String dropDownValue = 'how to play';

//class med changenotifier
class HowToPlay extends ChangeNotifier {
  String chosenChapter = 'how to play';

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
            value: dropDownValue,
            onChanged: (String? chosenValue) {
              //kallar på funktionen med hjälp av en provider
              Provider.of<HowToPlay>(context, listen: false)
                  .chooseChapter(chosenValue!);
              setState(() {
                dropDownValue = chosenValue; //kolla över detta
              });
            },
            //lista med de alternativ användaren får
            items: <String>[
              'how to play',
              'card values',
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
        Text(
          RuleText.returnRules(chosenText),
        ),
      ],
    );
  }
}
