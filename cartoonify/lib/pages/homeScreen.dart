import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cartoonify/pages/cameraScreen.dart';

class HomeScree extends StatefulWidget{
  var cameras;
  var path;
  HomeScree(this.cameras,this.path);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScree>
    with SingleTickerProviderStateMixin{
  String _path;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Cartoonify"),
        backgroundColor: Colors.orange,
      ),
      body: _bodyHome(),
      floatingActionButton: _bottomHome()
    );
  }

  Widget _bodyHome(){
    if (widget.path == null){
      return new Center(
        child: new Text(
          "Take a picture",
          textScaleFactor: 1.5,
        ),
      );
    } else{
      Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _path == null
                  ? null
                  : SizedBox(
                child: (null == null)
                    ? Image.file(File(_path))
                    : Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _bottomHome(){
    if (widget.path == null){
      return FloatingActionButton(
        tooltip: "Go to camera",
        child: Icon(Icons.photo_camera),
        onPressed: () => Navigator.push(context,
            new MaterialPageRoute(
                builder: (context) => new CameraScreen(widget.cameras))),
      );
    } else{
      FloatingActionButton.extended(
        tooltip: "Return to home",
        icon: Icon(Icons.undo),
        label: new Text("Return"),
        onPressed: () => Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))
      );
    }
  }
}