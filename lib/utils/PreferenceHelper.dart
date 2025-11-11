
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper{

  void saveAll(Map<String,dynamic> settings) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('darkmode', settings['darkmode']);
  }

  Future<Map<String,dynamic>> readAll() async {
    final pref = await SharedPreferences.getInstance();
    Map<String,dynamic> map = {};
    map['darkmode'] = pref.getBool('darkmode');
    return map;
  }
}

