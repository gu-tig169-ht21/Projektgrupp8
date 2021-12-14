import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'card_customization.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkThemeValue = false;
  bool soundValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
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

  Widget _darkTheme() {
    return Align(
        alignment: const Alignment(0.3, 0.1),
        child: FractionallySizedBox(
            widthFactor: 0.2,
            heightFactor: 0.1,
            child: SwitchListTile(
                title: const Text('Dark Theme'),
                value: darkThemeValue,
                onChanged: (bool value) {
                  setState(() {
                    darkThemeValue = value;
                  });
                })));
  }

  Widget _sound() {
    return Align(
        alignment: const Alignment(0.3, 0.3),
        child: FractionallySizedBox(
            widthFactor: 0.2,
            heightFactor: 0.1,
            child: SwitchListTile(
                title: const Text('Sound'),
                value: soundValue,
                onChanged: (bool value) {
                  setState(() {
                    soundValue = value;
                  });
                })));
  }

  Widget _cardCustomizationButton() {
    return Align(
        alignment: const Alignment(0.2, 0.9),
        child: FractionallySizedBox(
            widthFactor: 0.3,
            heightFactor: 0.1,
            child: ElevatedButton(
                child: const Text('Card Customization'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomizationPage()));
                })));
  }
}
