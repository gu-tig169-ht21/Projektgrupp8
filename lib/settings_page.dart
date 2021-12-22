import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_customization.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

//lägg till en setting för hur många kortlekar spelaren vill använda, ta in en int så hanterar vi det sen!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
class _SettingsState extends State<Settings> {
  bool soundValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Stack(
          children: [
            _darkTheme(),
            _sound(),
            _cardCustomizationButton(),
            //_settingsDarkTheme(),
            //  _settingsLightTheme(),
          ],
        ));
  }

/*
  Widget buildItem(String item) {
    return ListTile(
      title: const Text('Darktheme'),
      leading: FlutterSwitch(
          width: 125.0,
          height: 55.0,
          valueFontSize: 25.0,
          toggleSize: 45.0,
          value: darkThemeValue,
          borderRadius: 30.0,
          padding: 8.0,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              darkThemeValue = val;
            });
          }),
    );
  }*/

  //darktheme knappen
  Widget _darkTheme() {
    return Align(
      alignment: const Alignment(0.3, -0.4),
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.1,
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
      ),
    );
  }

  Widget _sound() {
    return Align(
        alignment: const Alignment(0.2, -0.1),
        child: FractionallySizedBox(
            widthFactor: 0.85,
            heightFactor: 0.1,
            child: SwitchListTile(
                title: const Text('Sound'),
                subtitle: const Text('Turns sound off'),
                secondary: const Icon(Icons.volume_off_sharp),
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: Colors.green,
                activeTrackColor: Colors.green[200],
                value: soundValue,
                onChanged: (bool value) {
                  setState(() {
                    //lägga till en icon för när ljudet är unmutat
                    soundValue = value;
                  });
                })));
  }

  Widget _cardCustomizationButton() {
    return Align(
        alignment: const Alignment(0, 0.8),
        child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.1,
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
            )));
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
