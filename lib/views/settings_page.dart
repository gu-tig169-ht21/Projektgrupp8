import 'package:flutter/material.dart';
import 'package:my_first_app/game_engine/blackjack.dart';
import 'package:my_first_app/models/number_of_decks.dart';
import 'card_customization_page.dart';
import 'package:provider/provider.dart';
import '../models/theme_mode_switch.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          _numberOfDecks(),
          _changeTheme(context),
          _cardCustomizationButton(context)
        ],
      ),
    );
  }

//widget för att ändra temat dark/standard
  Widget _changeTheme(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'Change Theme',
      ),
      subtitle: const Text('Changes the screen theme'),
      secondary: Icon(
          //ändrar ikonen
          Provider.of<ChangeTheme>(context, listen: true).getThemeModeSwitch
              ? Icons.dark_mode
              : Icons.light_mode_outlined),
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: Colors.green,
      activeTrackColor: Colors.green[200],
      //ändrar temat
      value: Provider.of<ChangeTheme>(context, listen: true).getThemeModeSwitch,
      onChanged: (bool? value) {
        Provider.of<ChangeTheme>(context, listen: false)
            .changeDarkTheme(value!);
      },
    );
  }

//widget för att skapa knappen till Card Customization
  Widget _cardCustomizationButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brush),
      title: const Text('Card Customization'),
      subtitle: const Text('Change card theme'),
      trailing: IconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomizationPage()));
        },
        icon: const Icon(
          Icons.double_arrow,
        ),
      ),
    );
  }
}

//widget för att ändra antal kortlekar i spelet
Widget _numberOfDecks() {
  return ListTile(
    leading: const Icon(Icons.exposure_sharp),
    title: const Text(
      'Number of decks',
    ),
    subtitle: const Text('Sets the number of decks'),
    trailing: Consumer<ChangeNumberOfDecks>(
      builder: (context, state, child) {
        return DropdownButton<String>(
          value:
              '${Provider.of<ChangeNumberOfDecks>(context, listen: false).getSelectedNumberOfDecks}',
          onChanged: (String? newValue) {
            Provider.of<BlackJackGameEngine>(context, listen: false)
                .addDecks(newValue!);
            Provider.of<ChangeNumberOfDecks>(context, listen: false)
                .setSelectedDecks(newValue);
          },
          items: Provider.of<ChangeNumberOfDecks>(context, listen: false)
              .getNumberDecks
              .map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        );
      },
    ),
  );
}
