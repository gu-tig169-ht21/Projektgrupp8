import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeTheme extends ChangeNotifier {
  var _thememode = ThemeMode.light;
  bool _themeModeSwitch = false;
  get getThemeMode {
    return _thememode;
  }

  get getThemeModeSwitch {
    return _themeModeSwitch;
  }

  void changeDarkTheme(bool value) {
    if (value == true) {
      _thememode = ThemeMode.dark;
      _themeModeSwitch = true;
      notifyListeners();
    } else {
      _thememode = ThemeMode.light;
      _themeModeSwitch = false;
      notifyListeners();
    }
  }
}
