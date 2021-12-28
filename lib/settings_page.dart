import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_customization.dart';
import 'package:provider/provider.dart';

//TODO: tog bort const från filer game_page(rad 56) och start_page (rad 143)

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

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
            _cardCustomizationButton(),
            //_settingsDarkTheme(),
            //  _settingsLightTheme(),
          ],
        ));
  }

  Widget _darkTheme() {
    return Align(
      alignment: const Alignment(0.3, -0.4),
      child: SwitchListTile(
          title: const Text(
            'Dark Theme',
          ),
          subtitle: const Text('Sets the theme to dark'),
          secondary: const Icon(Icons.dark_mode),
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: Colors.green,
          activeTrackColor: Colors.green[200],
          value: Provider.of<ChangeTheme>(context, listen: true)
              .getThemeModeSwitch,
          onChanged: (bool? value) {
            Provider.of<ChangeTheme>(context, listen: false)
                .changeDarkTheme(value!);
          }

          // provider istället för setState
          //thememode set till darktheme när man trycker på knappen

          ),
    );
  }

  Widget _sound() {
    return Align(
        alignment: const Alignment(0.2, -0.1),
        child: SwitchListTile(
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
            }));
  }

  Widget _cardCustomizationButton() {
    return Align(
        alignment: const Alignment(0, 0.8),
        child: ElevatedButton(
          child: const Text('Card Customization'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomizationPage()));
          },
          style: ElevatedButton.styleFrom(
            //   primary: Colors.green[200],
            //   onPrimary: Colors.black87,
            textStyle:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ));
  }
}

Widget _numberOfDecks() {
  return Consumer<ChangeNumberOfDecks>(
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
  );
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
