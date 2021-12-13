import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _Settings extends State<Settings> {

bool darkThemeValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text("Settings"),
      centerTitle: true,
    )
    body: Column(
      children: [],
    ),
    );
  }
  Widget _buildSettingsDarkTheme(){
    return ThemeData.DarkTheme;
    
    /*if (darkThemeValue == true){
    return ThemeData(DarkTheme);
    }
    else {
      return ThemeData(StandardTheme);
      }*/
    
}
}