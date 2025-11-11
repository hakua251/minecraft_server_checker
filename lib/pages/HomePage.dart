
import 'package:flutter/material.dart';
import 'package:minecraft_server_checker/pages/AboutPage.dart';
import 'package:minecraft_server_checker/pages/SettingPage.dart';
import 'package:minecraft_server_checker/utils/DataStorge.dart';
import 'package:minecraft_server_checker/utils/StringResources.dart';
import 'package:provider/provider.dart';

import '../model/MinecraftServerModel.dart';
import '../ui/ServerCard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.data});

  final DataStorage data;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    final _formKey = GlobalKey<FormState>();
    final _searchController = TextEditingController();
    final _nameController = TextEditingController();
    final _hostController = TextEditingController();

    @override
    void initState() {
      super.initState();

      final serverModelList = context.read<ServerModelList>();
      _nameController.text = StringResources.getString('default_server_name');
      _hostController.text = '';
      widget.data.readData().then((data) {
        setState(() {
          if(data!=null){
            for(var d in data){
              serverModelList.addModel(MinecraftServerModel.fromJson(d));
            }
            serverModelList.pingAll(3000);
          }
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Drawer(
        width: 200,
        child: ListView(
            padding: EdgeInsets.zero,
            children: [
                DrawerHeader(
                decoration: BoxDecoration(color: theme.colorScheme.inversePrimary),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        width: 100,
                        height: 100,
                        image: AssetImage('assets/images/potato.png'),
                    ),
                ],)
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title:   Text(StringResources.getString('ui_setting'),style: theme.textTheme.titleLarge,),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => SettingPage(),
                      )
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title:   Text(StringResources.getString('ui_about'),style: theme.textTheme.titleLarge,),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => AboutPage(),
                      )
                  );
                },
              ),
            ]
        )
      ),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: DrawerButton(),
        title: TextField(
          onChanged: (_){
            setState(() {});
            },
          controller: _searchController,
          autofocus: false,
          decoration: InputDecoration(
              hintText: StringResources.getString('ui_search_hint'),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(90.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              filled: false,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add_outlined,size: 30),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_){
                      return AlertDialog(
                        title: Text(StringResources.getString('ui_new_server_record'),style: theme.textTheme.titleMedium,),
                        actions: [
                          TextButton(
                              onPressed: (){Navigator.of(context).pop();},
                              child: Text(StringResources.getString('ui_cancel'))
                          ),
                          TextButton(
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  final serverModelList = context.read<ServerModelList>();
                                  serverModelList.addModel(MinecraftServerModel(serverName: _nameController.text, serverHost: _hostController.text, iconBase64: ""));
                                  serverModelList.saveModel();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(StringResources.getString('ui_confirm'))
                          ),
                        ],
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: StringResources.getString('ui_server_name'),
                                ),
                                controller: _nameController,
                                validator: (value){
                                  if(value!.isEmpty)  {return StringResources.getString('ui_server_name_tips');}
                                  return null;
                                },
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: StringResources.getString('ui_server_host'),
                                ),
                                controller: _hostController,
                                validator: (value){
                                  if(value!.isEmpty)  {return StringResources.getString('ui_server_host_tips');}
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                );
              },

          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Consumer<ServerModelList>(
            builder: (context, serverModelList, child) {
              return serverModelList.models.isNotEmpty ? ListView.builder(
                itemCount: serverModelList.models.length,
                itemBuilder: (context, index) =>
                    Visibility(
                        visible:serverModelList.models[index].serverName.toLowerCase().contains(_searchController.text.toLowerCase())||
                            _searchController.text == '',
                        child: ServerCard(
                          model: serverModelList.models[index],
                          index: index,
                        )
                    ),
              ):Center(child: Text(StringResources.getString('ui_user_manual'),style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          final serverModelList = context.read<ServerModelList>();
          serverModelList.pingAll(3000);
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}