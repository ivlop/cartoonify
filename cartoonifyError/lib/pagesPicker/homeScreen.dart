import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cartoonify/model.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{
  //File _image;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartoonify',
      home: new Scaffold(
        key: _scaffoldKey,
          appBar: new AppBar(
            title: new Text('Cartoonify'),
            backgroundColor: Colors.orange,
            actions: <Widget>[
              ScopedModelDescendant<AppModel>(
                builder: (context, child, model){
                  if(model.buttons == 0){
                    return IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: model.gallery,
                    );
                  }
                  else if(model.buttons == 2){
                    return IconButton(
                      icon: Icon(Icons.share),
                      onPressed: model.shareImage,
                      tooltip: "Press to share",
                    );
                  }else if(model.buttons == 3) {
                    return IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: (){model.showAlert(context);},
                      tooltip: "Press to delete all photos",
                    );
                  }else if(model.buttons == 5){
                    return IconButton(
                      icon: Icon(Icons.share),
                      onPressed: model.shareImageFromGallery,
                      tooltip: "Press to share",
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
                    children: model.buttons==0? <Widget>[
                      FloatingActionButton(
                        onPressed: model.getImage,
                        tooltip: 'Take a picture',
                        child: Icon(Icons.photo_camera),
                      ),
                    ]: model.buttons==1? <Widget>[
                      FloatingActionButton.extended(
                        label: new Text("Cancel"),
                        icon: Icon(Icons.cancel,),
                        tooltip: "Cancel transform",
                        backgroundColor: Colors.red,
                        onPressed: model.resetMsg,
                      ),
                    ]: model.buttons==2?<Widget>[
                      FloatingActionButton(
                        child: Icon(Icons.home,),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]:model.buttons==3 || model.buttons == 4 ?<Widget>[
                      FloatingActionButton.extended(
                        icon: Icon(Icons.undo,),
                        label: Text("Go back"),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]:model.buttons==5 ?<Widget>[
                      FloatingActionButton.extended(
                        icon: Icon(Icons.undo,),
                        label: Text("Go back"),
                        tooltip: "Go to beginning",
                        onPressed: model.gallery,
                      ),
                    ]: <Widget>[]
                );
              }
          ),
      ),
    );
  }


}