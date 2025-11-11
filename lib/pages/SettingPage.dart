import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_server_checker/utils/PreferenceHelper.dart';
import 'package:minecraft_server_checker/utils/StringResources.dart';
import 'package:provider/provider.dart';

import '../model/SettingModel.dart';

class SettingPage extends StatefulWidget{
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final pref = PreferenceHelper();
    final settingModel = context.read<SettingModel>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(StringResources.getString('ui_setting')),
      ),
      body: ListView(
        children: [
          SwitchListTile(
              value: settingModel.darkMode,
              onChanged: (value){
                settingModel.toggleDarkMode(value);
                pref.saveAll(settingModel.toJson());
              },
              title: Text(StringResources.getString('ui_setting_dark_mode'),style: theme.textTheme.titleLarge,),
              secondary: Icon(Icons.dark_mode),
          )
        ],
      ),
    );
  }
}