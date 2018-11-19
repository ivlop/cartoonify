import 'package:flutter/material.dart';
import 'package:cartoonify/pages/cameraScreen.dart';

class HomeScreen extends StatefulWidget{
  var cameras;
  var path;
  HomeScreen(this.cameras,this.path);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
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

  static setPath(String value){
    widget.path = value;
  }
}