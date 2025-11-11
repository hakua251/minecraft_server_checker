import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataStorage{

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path  = directory.path;
    return File('$path/serverdata.json');
  }

  Future<List<Map<String, dynamic>>?> readData() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final decoded = jsonDecode(contents) as List<dynamic>;
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      return null;
    }
  }

    Future<bool> writeData(List<Map<String, dynamic>> json) async {
    try{
      final file = await _localFile;
      final jsonString = jsonEncode(json);
      file.writeAsString(jsonString);
      return true;
    }
    catch(e){

    }
    return false;
  }
}