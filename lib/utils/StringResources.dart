import 'dart:convert';

import 'package:flutter/services.dart';

class StringResources {
  static Map<String, String> _strings = {};

  static Future<void> loadStrings([String language = 'zh']) async {
    try {
      final String jsonString = await rootBundle.loadString(
          'assets/lang/strings_$language.json');

      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      _strings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {

    }
  }

  static String getString(String key) => _strings[key] ?? '';
}

