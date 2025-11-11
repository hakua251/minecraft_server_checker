

import 'package:flutter/cupertino.dart';
import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:minecraft_server_checker/utils/DataStorge.dart';
class MinecraftServerModel{
  MinecraftServerModel({required this.serverName,required this.serverHost,required this.iconBase64});
  String iconBase64;
  String serverName;
  String serverHost;

  bool valid = false;

  String serverMotd = "A Minecraft Server";

  String edition = "Java";
  String version = "";
  String type = "";
  int latency = 0;

  int onlinePlayers = 0;
  int maxPlayers = 0;

  MinecraftServerModel.fromJson(Map<String, dynamic> json)
      : iconBase64 = json['icon'] as String,
        serverName = json['name'] as String,
        serverHost = json['host'] as String;

  Map<String, dynamic> toJson() => {'name': serverName, 'host': serverHost,'icon':iconBase64};



  Future<bool> pingServer(int timeout) async{
    final host = serverHost.split(':').first;
    final port = serverHost.split(':').length > 1 ? int.parse(serverHost.split(':').last):25565;

    try{
      final server = await ping(host,port: port,timeout: Duration(milliseconds: timeout));
      if(server!=null){
        version = server.response!.version.name;
        iconBase64 = server.response!.favicon;
        serverMotd = server.response!.description.description;
        onlinePlayers = server.response!.players.online;
        maxPlayers = server.response!.players.max;
        latency = server.ping!;
        valid = true;
        return true;
      }
    }
    catch (e){
      valid = false;
    }
    return false;
  }
}

class ServerModelList extends ChangeNotifier{
  List<MinecraftServerModel> models  = [];
  final data = DataStorage();

  void addModel(MinecraftServerModel model) {
    models.add(model);
  }

  void removeModel(int index) {
    models.removeAt(index);
  }

  Future<void> saveModel() async {
    await data.writeData(List.generate(models.length, (i) => models[i].toJson()));
    notifyListeners();
  }

  void updateWidget(){
    notifyListeners();
  }
  Future<void> pingAll(int timeout) async {
    models.asMap().forEach((index,m){
      m.pingServer(timeout).then((valid){
        if(valid){
          saveModel();
        }
      });
    });

  }
}