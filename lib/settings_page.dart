import 'package:flutter/material.dart';
import 'card_customization.dart';
import 'package:provider/provider.dart';

//TODO: tog bort const från filer game_page(rad 56) och start_page (rad 143)

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          _numberOfDecks(),
          _darkTheme(context),
          _cardCustomizationButton(context)
        ],
      ),
    );
  }

//widget för att ändra temat dark/standard
  Widget _darkTheme(BuildContext context) {
    return SwitchListTile(
      title: const Text(
        'Change Theme',
      ),
      subtitle: const Text('Changes the screen theme'),
      secondary: Icon(
          Provider.of<ChangeTheme>(context, listen: true).getThemeModeSwitch
              ? Icons.dark_mode
              : Icons.light_mode_outlined),
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: Colors.green,
      activeTrackColor: Colors.green[200],
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
          value: Provider.of<ChangeNumberOfDecks>(context, listen: false)
              .getSelectedNumberOfDecks,
          onChanged: (String? newValue) {
            Provider.of<ChangeNumberOfDecks>(context, listen: false)
                .setSelectedDecks(newValue!);
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

//provider för att ändra antal kortlekar
class ChangeNumberOfDecks with ChangeNotifier {
  final List<String> _numberDecks = ['1', '2', '3', '4', '5'];
  late String _selectedNumberOfDecks = '1';

  List<String> get getNumberDecks => _numberDecks;
  String get getSelectedNumberOfDecks => _selectedNumberOfDecks;

  void setSelectedDecks(String x) {
    _selectedNumberOfDecks = x;
    notifyListeners();
  }
}

//Provider för att ändra mellan darktheme/standardtheme
class ChangeTheme extends ChangeNotifier {
  var _thememode = ThemeMode.light;
  bool themeModeSwitch = false;
  get getThemeMode {
    return _thememode;
  }

  get getThemeModeSwitch {
    return themeModeSwitch;
  }

  void changeDarkTheme(bool value) {
    if (value == true) {
      _thememode = ThemeMode.dark;
      themeModeSwitch = true;
      notifyListeners();
    } else {
      _thememode = ThemeMode.light;
      themeModeSwitch = false;
      notifyListeners();
    }
  }
}
