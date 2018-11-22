import 'dart:io';
import 'dart:async';
import 'package:cartoonify/pagesPicker//transformedImageScreen.dart';
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

  /*Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }*/

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
                  if(model.image !=null){
                    return IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: model.deletePressed,
                    );
                  }else {
                    return new Container();
                  }
                },
              )

            ],
          ),
          body: ScopedModelDescendant<AppModel>(
            builder: (context, child, model){
              return Center(child: model.msg);
              /*return Center(
                child: model.image == null
                    ? new Text('Take a picture to convert', textScaleFactor: 1.5,)
                    : new Image.file(model.image),

              );*/
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
                      FloatingActionButton.extended(
                        label: new Text("Home"),
                        icon: Icon(Icons.home,),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]: <Widget>[]
                );
              }
          ),
      ),
    );
  }


}