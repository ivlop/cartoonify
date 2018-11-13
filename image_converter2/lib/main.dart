import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp>{
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
          appBar: new AppBar(title: new Text('Image Converter'),
          ),
          body: new Center(child: _image == null? new Text('No image to convert'):new Image.file(_image),
          ),
          floatingActionButton:Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.delete, color: Colors.white,),
                  mini: true,
                  onPressed: (){},
                ),
                FloatingActionButton(onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.photo_camera),
                ),
              ]
          )
      ),
    );
  }
}

