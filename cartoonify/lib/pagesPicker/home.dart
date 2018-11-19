import 'dart:io';
import 'dart:async';
import 'package:cartoonify/pages/transformedImageScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(HomePantalla());

class HomePantalla extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _MyAppState();

}

class _MyAppState extends State<HomePantalla>{
  File _image;

  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Image converter',
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Image Converter'),
            actions: _image ==null
                ? null
                : <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _replayPressed,
                  )
            ],
          ),
          body: new Center(
            child: _image == null
                ? new Text('Take a picture to convert', textScaleFactor: 1.5,)
                : new Image.file(_image),
          ),
          floatingActionButton:Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: _image==null? <Widget>[
                FloatingActionButton(onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.photo_camera),
                ),
              ]: <Widget>[
                /*FloatingActionButton(
                  child: Icon(Icons.delete, color: Colors.white,),
                  mini: true,
                  backgroundColor: Colors.red,
                  onPressed: _replayPressed,
                ),*/
                FloatingActionButton.extended(
                  label: new Text("Transform"),
                  icon: Icon(Icons.check,),
                  backgroundColor: Colors.greenAccent,
                  onPressed: () => Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (context) => new TransformedImageScreen())),

                ),
              ]
          ),
      ),
    );
  }

  void _replayPressed() {
    setState(() {
      _image = null;
    });
  }
}