import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cartoonify/model.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    bool res = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!res) {
      await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartoonify',
      home: new WillPopScope(
        onWillPop: () => Future.value(false),
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: new Text('Cartoonify'),
            backgroundColor: Colors.orange,
            actions: <Widget>[
              ScopedModelDescendant<AppModel>(
                builder: (context, child, model){
                  if(model.buttons == 1){
                    return IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: model.gallery,
                    );
                  }
                  else if(model.buttons == 3){
                    return IconButton(
                      icon: Icon(Icons.share),
                      onPressed: model.shareImage,
                      tooltip: "Press to share",
                    );
                  }else if(model.buttons == 4) {
                    return IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: (){model.onDeleteAllPhotosClicked();},
                      tooltip: "Press to delete all photos",
                    );
                  }else if(model.buttons == 6){
                    return IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: model.onDeletePhotoClicked,
                      tooltip: "Press to delete",
                    );
                  }else{
                    return new Container();
                  }
                },
              )
            ],
          ),
          body: ScopedModelDescendant<AppModel>(
              builder: (context, child, model){
                return Center(child: model.msg);
              }
          ),
          floatingActionButton:ScopedModelDescendant<AppModel>(
              builder: (context, child, model) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: model.buttons==1? <Widget>[
                      FloatingActionButton(
                        onPressed: model.getImage,
                        tooltip: 'Take a picture',
                        child: Icon(Icons.photo_camera),
                      ),
                    ]: model.buttons==2? <Widget>[
                      FloatingActionButton.extended(
                        label: new Text("Cancel"),
                        icon: Icon(Icons.cancel,),
                        tooltip: "Cancel transform",
                        backgroundColor: Colors.red,
                        onPressed: model.resetMsgCancel,
                      ),
                    ]: model.buttons==3?<Widget>[
                      FloatingActionButton(
                        child: Icon(Icons.home,),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]:model.buttons==4 || model.buttons == 5 ?<Widget>[
                      FloatingActionButton.extended(
                        icon: Icon(Icons.undo,),
                        label: Text("Go back"),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]:model.buttons==6 ?<Widget>[ new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: <Widget>[
                        FloatingActionButton(
                          child: Icon(Icons.share,),
                          tooltip: "Press to share",
                          onPressed: model.shareImageFromGallery,
                          mini: true,
                        ),
                        FloatingActionButton.extended(
                          icon: Icon(Icons.undo,),
                          label: Text("Go back"),
                          tooltip: "Go to beginning",
                          onPressed: model.gallery,
                        ),
                      ],
                    ),
                    ]: <Widget>[]
                );
              }
          ),
        ),
      )
    );
  }


}