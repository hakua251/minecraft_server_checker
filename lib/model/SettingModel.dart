import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingModel extends ChangeNotifier{
  bool darkMode = false;

  SettingModel(){
    _loadFromPref();
  }

  SettingModel.fromJson(Map<String, dynamic> json)
      :darkMode = json['darkmode'] as bool;

  Map<String, dynamic> toJson() => {'darkmode': darkMode};

  void _loadFromPref() async{
    final pref = await SharedPreferences.getInstance();
    this.darkMode = pref.getBool('darkmode') ?? false;
    notifyListeners();
  }
  void toggleDarkMode(bool darkMode){
      this.darkMode = darkMode;
      notifyListeners();
  }
}