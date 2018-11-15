import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



void main() => runApp(new MaterialApp(
  home: new HomeScreen(),
));

class HomeScreen extends StatelessWidget{
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
                builder: (context) => new CameraScreen())),
      ),
    );
  }

}



class CameraScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Camera screen"),
      ),
      body: new Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Aqui deberia de aparecer la camara :)",
            textScaleFactor: 1.7,
            textAlign: TextAlign.center,
          ),
          new RaisedButton(
              child: new Text("Go back"),
              onPressed: () => Navigator.pop(context)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: (){},
        backgroundColor: Colors.red,
        foregroundColor: Colors.yellow,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
