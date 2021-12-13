import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkThemeValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [],
      ),
    );
  }

  void _buildSettingsDarkTheme() {
    //return ThemeMode.dark;

    /*if (darkThemeValue == true){
    return ThemeData(DarkTheme);
    }
    else {
      return ThemeData(StandardTheme);
      }*/
  }
}
