import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_customization.dart';
import 'package:provider/provider.dart';

//TODO: tog bort const från filer game_page(rad 56) och start_page (rad 143)

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool soundValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          _numberOfDecks(),
          _darkTheme(),
          _sound(),
          _cardCustomizationButton()
          //_settingsDarkTheme(),TA BORT??
          //  _settingsLightTheme(),TA BORT????
        ],
      ),
    );
  }

//widget för att ändra temat dark/standard
  Widget _darkTheme() {
    return SwitchListTile(
        title: const Text(
          'Dark Theme',
        ),
        subtitle: const Text('Sets the theme to dark'),
        secondary: Icon(
            Provider.of<ChangeTheme>(context, listen: true).getThemeModeSwitch
                ? Icons.dark_mode
                : Icons.light_mode_outlined),
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: Colors.green,
        activeTrackColor: Colors.green[200],
        value:
            Provider.of<ChangeTheme>(context, listen: true).getThemeModeSwitch,
        onChanged: (bool? value) {
          Provider.of<ChangeTheme>(context, listen: false)
              .changeDarkTheme(value!);
        }

        // provider istället för setState
        //thememode set till darktheme när man trycker på knappen

        );
  }

//widget för ljudet av/på
  Widget _sound() {
    return SwitchListTile(
      title: const Text('Sound'),
      subtitle: const Text('Turns sound off'),
      secondary: const Icon(Icons.volume_off_sharp),
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: Colors.green,
      activeTrackColor: Colors.green[200],
      value: soundValue,
      onChanged: (bool value) {
        //lägga till en icon för när ljudet är unmutat
        soundValue = value;
      },
    );
  }

//widget för knapp till --> card customization
  // Widget _cardCustomizationButton() {
  //   return ElevatedButton(
  //     child: const Text('Card Customization'),
  //     onPressed: () {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const CustomizationPage()));
  //     },
  //     // style: ElevatedButton.styleFrom(
  //     //   textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //     // ),
  //   );
  // }
  Widget _cardCustomizationButton() {
    return ListTile(
      leading: const Icon(Icons.brush),
      title: const Text('Card Customization'),
      subtitle: const Text('Change card theme'),
      trailing: IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomizationPage()));
        },
        icon: const Icon(
          Icons.east,
        ),
      ),
    );
  }
}

Widget _numberOfDecks() {
  return ListTile(
      leading: const Icon(Icons.trending_neutral),
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
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        },
      ));
}

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
