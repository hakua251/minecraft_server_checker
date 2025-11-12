import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/MinecraftServerModel.dart';
import '../utils/StringResources.dart';

class ServerCard extends StatefulWidget{
  const ServerCard({super.key, required this.model, required this.index});

  final MinecraftServerModel model;
  final int index;

  @override
  State<ServerCard> createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _hostController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.model.serverName;
    _hostController.text = widget.model.serverHost;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPress: (){
        _showPopupMenu(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInImage(
                  width: 64,
                  height: 64,
                  image: widget.model.iconBase64 == '' ?
                        (AssetImage('assets/images/unknown_server.png') as ImageProvider):
                        (MemoryImage(base64.decode(widget.model.iconBase64.split(',').last)) as ImageProvider),
                  placeholder: AssetImage('assets/images/unknown_server.png'),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.model.serverName,maxLines: 1,style: theme.textTheme.titleLarge),
                      widget.model.valid ? Text(widget.model.serverMotd.trim(),maxLines: 1,):Text('无法连接到服务器',maxLines: 1,style: TextStyle(color: Colors.red),),
                      widget.model.valid ? Row(
                        children: [
                          ServerTags(tag: widget.model.edition),
                          ServerTags(tag: widget.model.version),
                        ],
                      ):Container()
                    ],
                  ),
                ),
                SizedBox(width: 10.0,),
                widget.model.valid ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text('${widget.model.onlinePlayers}/${widget.model.maxPlayers}',style: theme.textTheme.bodyLarge,),
                      ],
                    ),
                    TextButton(
                        onPressed: null,
                        child: Text('${widget.model.latency}ms',
                          style: TextStyle(
                              color:
                              widget.model.latency<100 ? Colors.green :
                              widget.model.latency<200 ? Colors.orange :Colors.red ),)
                    ),
                  ],
                ) : Icon(Icons.close,color: Colors.red,size: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async  {
    final RenderBox card = context.findRenderObject() as RenderBox;
    final Offset cardPosition = card.localToGlobal(Offset.zero);
    final provider = context.read<ServerModelList>();

    final result = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      position: RelativeRect.fromLTRB(
        cardPosition.dx + card.size.width,
        cardPosition.dy + 10,
        cardPosition.dx,
        cardPosition.dy,
      ),
      items: [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text(StringResources.getString('ui_edit')),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete, size: 20),
              SizedBox(width: 8),
              Text(StringResources.getString('ui_delete')),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.vertical_align_top, size: 20),
              SizedBox(width: 8),
              Text(StringResources.getString('ui_topping')),
            ],
          ),
        ),
      ],
    );
    switch(result){
      case 0 :
        showDialog(
            context: context,
            builder: (_){
              return AlertDialog(
                title: Text(StringResources.getString('ui_edit_server_record'),style: Theme.of(context).textTheme.titleMedium,),
                actions: [
                  TextButton(
                      onPressed: (){Navigator.of(context).pop();},
                      child: Text(StringResources.getString('ui_cancel'))
                  ),
                  TextButton(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          widget.model.serverName = _nameController.text;
                          widget.model.serverHost = _hostController.text;
                          provider.saveModel();
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
      case 1 :
        provider.removeModel(widget.index);
        provider.saveModel();
      case 2 :
        provider.models.insert(0,widget.model);
        provider.removeModel(widget.index+1);
        provider.saveModel();
    }
  }
}

class ServerTags extends StatelessWidget{
  const ServerTags({super.key, required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5,right: 2.5),
          child:  Text(tag,style: Theme.of(context).textTheme.labelSmall,),
        ),
      );
  }
}