import 'package:flutter/material.dart';
import 'package:minecraft_server_checker/model/MinecraftServerModel.dart';
import 'package:minecraft_server_checker/model/SettingModel.dart';
import 'package:minecraft_server_checker/pages/HomePage.dart';
import 'package:minecraft_server_checker/utils/DataStorge.dart';
import 'package:minecraft_server_checker/utils/StringResources.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StringResources.loadStrings('zh');
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>ServerModelList()),
          ChangeNotifierProvider(create: (context)=>SettingModel())
        ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (BuildContext context, settingModel, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner:false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
              brightness: settingModel.darkMode ? Brightness.dark:Brightness.light,
            ),
          ),
          home: MyHomePage(data: DataStorage(),),
        );
      },

    );
  }
}



