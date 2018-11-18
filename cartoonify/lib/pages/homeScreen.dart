import 'package:flutter/material.dart';
import 'package:cartoonify/pages/cameraScreen.dart';

class HomeScreen extends StatefulWidget{
  var cameras;
  HomeScreen(this.cameras);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin{

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
      body: new Center(
        child: new Text(
          "Take a picture",
          textScaleFactor: 1.5,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Go to camera",
        child: Icon(Icons.photo_camera),
        onPressed: () => Navigator.push(context,
            new MaterialPageRoute(
                builder: (context) => new CameraScreen(widget.cameras))),
      ),
    );
  }

}